//
//  addAccount.swift
//  budget
//
//  Created by wov on 2021/7/10.
//

import SwiftUI

struct addAccount: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showAddAccount: Bool
    
    @State private var accountName: String = ""
    @State private var accountDesc: String = ""
    
    //TODO:修改成传参数过来...
    @FetchRequest(
        entity: Account.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Account.name, ascending: false)
        ],
        animation: .default
    ) var accounts: FetchedResults<Account>

    @FetchRequest(
        entity: BasedIE.entity(),
        sortDescriptors: [],
        animation: .default
    ) var ies: FetchedResults<BasedIE>
    
    
    @FetchRequest(
        entity: CreatedIE.entity(),
        sortDescriptors: [],
        animation: .default
    ) var cies: FetchedResults<CreatedIE>
    
    private func addAccount(){
        let newAccount = Account(context: viewContext)
        newAccount.name = accountName
        newAccount.desc = accountDesc
        newAccount.id = UUID()
        
        do {
            self.showAddAccount = false
            try viewContext.save()
        } catch {
            // Error handling
        }
    }
    
    
    private func deleteAccounts(offsets: IndexSet){
        offsets.map{ accounts[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    private func deleteIes(offsets: IndexSet){
        offsets.map{ ies[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    private func deleteCies(offsets: IndexSet){
        offsets.map{ cies[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    var body: some View {
        
        NavigationView{
            
            Form{
                Section{
                    HStack {
                        Text("账户名称")
                        TextField("账户名称",text:$accountName)
                    }
                    HStack {
                        Text("账户描述")
                        TextField("账户描述",text:$accountDesc)
                    }
                }
                
                Section(header:Text("所有账户")){
                    ForEach(self.accounts){ account in
                        HStack{
                            Text(account.name!)
                        }
                    }.onDelete(perform: deleteAccounts)
                }

//                Section(header:Text("滑动删除basedies，调试用")){
//                    ForEach(self.ies){ ie in
//                        HStack{
//                            Text(ie.name!)
//                        }
//                    }.onDelete(perform: deleteIes)
//                }
//
//
//                Section(header:Text("滑动删除createdies，调试用")){
//                    ForEach(self.cies){ cie in
//                        HStack{
//                            Text(  String("\(cie.name!)-\(cie.period)")  )
//                        }
//                    }.onDelete(perform: deleteCies)
//                }
                
                
            }
            
            .navigationBarTitle("账户管理", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.showAddAccount = false
                                    }, label: {
                                        Text("取消")
                                    }), trailing:
                                        Button(action: {
                                            self.addAccount()
                                        }, label: {
                                            Text("保存")
                                        }).disabled(accountName.isEmpty || accountDesc.isEmpty)
            )
        }
        
    }
}
