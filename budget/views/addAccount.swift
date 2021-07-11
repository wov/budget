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

    
    private func addAccount(){
        let newAccount = Account(context: viewContext)
        newAccount.name = accountName
        newAccount.desc = accountDesc
        newAccount.id = UUID()
        
        do {
            try viewContext.save()
            self.showAddAccount = false
        } catch {
            // Error handling
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
            }.navigationBarTitle("添加账户", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
//                                        self.addAccount()
                                        self.showAddAccount = false
                                    }, label: {
                                        Text("取消")
                                    }), trailing:
                                        Button(action: {
                                            self.addAccount()
                                        }, label: {
                                            Text("保存")
                                        })
            )
        }
        
    }
}

//struct addAccount_Previews: PreviewProvider {
//    static var previews: some View {
//        addAccount()
//    }
//}
