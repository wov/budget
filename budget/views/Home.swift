//
//  Home.swift
//  budget
//
//  Created by wov on 2021/6/30.
//

import SwiftUI
import CoreData

struct Home: View {
    
    @FetchRequest(
        entity: Account.entity(),
        sortDescriptors: [],
        animation: .default
    ) var accounts: FetchedResults<Account>
    
    
    
    @State private var showAddAccount: Bool = false

    var body: some View {
        NavigationView {
            
//            let _a = print("what in accounts .....")
            
//            let _ = print(accounts)

            List{
                ForEach(accounts) { account in
                    Section{
                        AccountsRow(account:account)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("2021-06")
            .toolbar(content: {
                Button(action: {
                    self.showAddAccount.toggle()
                }){
                    Text("添加账户")
                }
            })
        }
        .sheet(isPresented: $showAddAccount, content: {
            addAccount(showAddAccount:self.$showAddAccount)
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
