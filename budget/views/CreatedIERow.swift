//
//  CreatedIERow.swift
//  budget
//
//  Created by wov on 2022/1/16.
//

import SwiftUI
import CoreData


struct CreatedIERow: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var ie:CreatedIE
    
    @State private var basedie:BasedIE?
    @State private var showModifyIE: Bool = false
    
    
    private func getSubTitle(ie:CreatedIE) -> String{
        var subTitle:String = ""
        
        if(ie.basedie != nil){
            let bie = self.getBasedIE(id: ie.basedie!)
            if(bie?.amounttype == "dynamicAmount"){
                subTitle += "动态"
            }
            if(bie?.amounttype == "fixedAmount"){
                subTitle += "固定"
            }
            
        }
        if(ie.type == "income"){
            subTitle += "收入"
        }
        if(ie.type == "expenses"){
            subTitle += "支出"
        }
        return subTitle
    }
    
    
    private func getBasedIE(id:UUID) -> BasedIE?{
        var bies:[BasedIE] = []
        do {
            let request:NSFetchRequest<BasedIE> = BasedIE.fetchRequest()
            request.predicate =  NSPredicate(format: "id == %@", id as CVarArg)
            bies = try viewContext.fetch(request) as [BasedIE]
        } catch let error as NSError {
            print("Error in fetch :\(error)")
        }
        return bies.first
    }
    
    
    
    
    var body: some View {
        
        let subTitle = getSubTitle(ie:ie)

        
        HStack{
            VStack(alignment: .leading){
                Text(ie.name!)
            }
            Spacer()
            
            Button( action: {
                self.showModifyIE.toggle()
            }){
                HStack{
                    VStack(alignment: .trailing){
                        Text(subTitle)
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                        Text("\(String(format:"%.2f", ie.amount))")
                            .foregroundColor(ie.type! == "income" ? .red : .green)
                    }
                    Image(systemName: "chevron.right")
                }
                
            }.sheet(isPresented: $showModifyIE, content: {
                
                modifyCreatedIE(showModifyIE:self.$showModifyIE,ie:ie,basedie: basedie,amount:ie.amount,name:ie.name!,accountType: ie.type!)
                    .environment(\.managedObjectContext, self.viewContext)
                
            })
        }
        

    }
}

