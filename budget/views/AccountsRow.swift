//
//  AccountsRow.swift
//  budget
//
//  Created by wov on 2021/6/28.
//

import SwiftUI
import CoreData

struct AccountsRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    var account : Account
    var period: Period
    
    @FetchRequest var ies : FetchedResults<CreatedIE>
    @State private var showAddIE: Bool = false
    @State private var showModifyIE: Bool = false
    

    init(account: Account,period: Period) {
        self.account = account
        self.period = period
        self._ies = FetchRequest(entity: CreatedIE.entity(),
                                 sortDescriptors: [  NSSortDescriptor(keyPath: \CreatedIE.type, ascending: false),
                                                     NSSortDescriptor(keyPath: \CreatedIE.amount, ascending: false)] ,
                                 predicate: NSPredicate(format: "period == %@ AND account = %@", period.id! as CVarArg , account.id! as CVarArg))
    }
    
    
    private func deleteIes(offsets: IndexSet){
        offsets.map{ ies[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            
        }
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
    
    
    var body: some View {
        
    
        Section(header: Text( account.name ?? "" )){
            ForEach(self.ies){ ie in
                    let subTitle = getSubTitle(ie:ie)
                    let basedie:BasedIE? = (ie.basedie != nil) ? getBasedIE(id: ie.basedie!) : nil
                    HStack{
                        VStack(alignment: .leading){
                            Text(subTitle)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                            Text(ie.name!)
                        }
                        Spacer()
                        
                        Button( action: {
                            self.showModifyIE.toggle()
                        }){
                            HStack{
                                Text("\(String(format:"%.2f", ie.amount))")
                                    .foregroundColor(ie.type! == "income" ? .red : .green)
                                Image(systemName: "chevron.right")
                            }
                        }.sheet(isPresented: $showModifyIE, content: {
                            modifyCreatedIE(self.$showModifyIE,ie,basedie)
                                .environment(\.managedObjectContext, self.viewContext)
                        })
                    }
            }.onDelete(perform: deleteIes)
            
            HStack{
                VStack(alignment: .leading){
                    Button( action: {
                        self.showAddIE.toggle()
                    }){
                        Text("新增项目")
                    }.sheet(isPresented: $showAddIE, content: {
                        addIE(showAddIE:self.$showAddIE, period: period, account: account)
                            .environment(\.managedObjectContext, self.viewContext)
                    })
                }
            }
            
        }
    }
}
