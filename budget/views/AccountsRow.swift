//
//  AccountsRow.swift
//  budget
//
//  Created by wov on 2021/6/28.
//

import SwiftUI

struct AccountsRow: View {
    
    var account : Account
    var ies : FetchedResults<CreatedIE>
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAddIE: Bool = false
    @State private var showModifyIE: Bool = false

    
    private func deleteIes(offsets: IndexSet){
        offsets.map{ ies[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    
    var body: some View {
        Section(header: Text(account.name ?? "")){
            
            ForEach(self.ies){ ie in
                if(ie.account == account.id){
                    HStack{
                        VStack(alignment: .leading){
                            let _ = print(ie)
                            
                            switch ie.type!{
                            case "income" :
                                Text("收入")
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                            case "expenses" :
                                Text("支出")
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                            default:
                                Text(ie.type!)
                            }
                            Text(ie.name!)
                        }
                        Spacer()
                        
                        Button( action: {
                            self.showModifyIE.toggle()
                        }){
                            HStack{
                                Text("\(ie.amount.clean)")
                                    .foregroundColor(ie.type! == "income" ? .red : .green)
                                Image(systemName: "chevron.right")
                            }
                        }.sheet(isPresented: $showModifyIE, content: {
                            modifyCreatedIE(self.$showModifyIE,ie,ie.amount)
                        })
                    }
                }
            }.onDelete(perform: deleteIes)
            
            HStack{
                VStack(alignment: .leading){
                    Button( action: {
                        self.showAddIE.toggle()
                    }){
                        Text("新增项目")
                    }.sheet(isPresented: $showAddIE, content: {
                        addIE(showAddIE:self.$showAddIE, account:account)
                    })
                }
            }
            
        }
    }
}
