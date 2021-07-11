//
//  Home.swift
//  budget
//
//  Created by wov on 2021/6/30.
//

import SwiftUI
import CoreData

struct Home: View {
    @Environment(\.managedObjectContext) private var viewContext
    var periodid:UUID
    
    @FetchRequest var accounts : FetchedResults<Account>
    @FetchRequest var ies : FetchedResults<CreatedIE>
    @State private var showAddAccount: Bool = false

    init(_ periodid:UUID ) {
        self.periodid = periodid
        self._accounts = FetchRequest(entity: Account.entity(), sortDescriptors: [])
        self._ies = FetchRequest(entity: CreatedIE.entity(), sortDescriptors: [] ,predicate: NSPredicate(format: "period == %@", periodid as CVarArg))
    }
        
    var body: some View {
        NavigationView {
            List{
                ForEach(accounts) { account in
                    AccountsRow(account:account,ies:ies)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("2021-06")
            .toolbar(content: {
                Button(action: {
                    self.showAddAccount.toggle()
                }){
                    Text("管理账户")
                }
            })
        }
        .sheet(isPresented: $showAddAccount, content: {
            addAccount(showAddAccount:self.$showAddAccount)
        })
    }
}
