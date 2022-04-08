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
        //        TODO：这里的写法比较骚气，以后看怎么改吧。。。
        if(period.id != nil && account.id != nil){
            self._ies =  FetchRequest(entity: CreatedIE.entity(),
                                      sortDescriptors: [  NSSortDescriptor(keyPath: \CreatedIE.type, ascending: false),
                                                          NSSortDescriptor(keyPath: \CreatedIE.amount, ascending: false)] ,
                                      predicate: NSPredicate(format: "period == %@ AND account = %@",
                                                             period.id! as CVarArg ,
                                                             account.id! as CVarArg))
        }else{
            self._ies  =  FetchRequest(entity: CreatedIE.entity(),
                                       sortDescriptors: [  NSSortDescriptor(keyPath: \CreatedIE.type, ascending: false),
                                                           NSSortDescriptor(keyPath: \CreatedIE.amount, ascending: false)] ,
                                       predicate: NSPredicate(format: "period == %@ AND account = %@",
                                                              UUID() as CVarArg ,
                                                              UUID() as CVarArg))
        }
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
            ForEach(self.ies, id: \.self){ ie in
                let basedie:BasedIE? = (ie.basedie != nil) ? getBasedIE(id: ie.basedie!) : nil
                CreatedIERow(ie:ie,basedie:basedie)
            }.onDelete(perform: deleteIes)
            
            HStack{
                VStack(alignment: .leading){
                    Button( action: {
                        self.showAddIE.toggle()
                    }){
                        Text("新增条目")
                    }.sheet(isPresented: $showAddIE, content: {
                        addIE(showAddIE:self.$showAddIE, period: period, account: account)
                            
                    })
                }
            }
            
        }
    }
}
