//
//  Home.swift
//  budget
//
//  Created by wov on 2021/6/30.
//

import SwiftUI
import CoreData
import Foundation

struct Home: View {
    @Environment(\.managedObjectContext) private var viewContext
    var periodid:UUID
    var currentPeriod : Period
    
    @FetchRequest var accounts : FetchedResults<Account>
    @FetchRequest var ies : FetchedResults<CreatedIE>
    
    @State private var showAddAccount: Bool = false
    
    init(_ period:Period ) {
        self.periodid = period.id!
        self.currentPeriod = period //FetchRequest(entity: Period.entity(),  sortDescriptors: [] ,predicate: NSPredicate(format: "id == %@", periodid as CVarArg))

        self._accounts = FetchRequest(entity: Account.entity(), sortDescriptors: [])
        self._ies = FetchRequest(entity: CreatedIE.entity(), sortDescriptors: [] ,predicate: NSPredicate(format: "period == %@", periodid as CVarArg))
    }
    
    private func calcRemind() -> Float{
        var remind: Float = 0.0
        for  ie in self.ies{
            if(ie.type == "income"){
                remind += Float(ie.amount)
            }else if(ie.type == "expenses"){
                remind -= Float(ie.amount)
            }
        }
        return remind
    }

    var body: some View {
        let remind:Float = calcRemind()
        VStack {
            List{
                Section{
                    HStack{
                        Text("本月结余")
                        Spacer()
                        Text("\(String(format:"%.2f", remind))")
                    }
                }
                ForEach(accounts) { account in
                    AccountsRow(account:account,period:currentPeriod)
                }
                
                Section{
                        
                    
                }
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("\(self.currentPeriod.year!)-\(self.currentPeriod.month!)")
            .toolbar{
                ToolbarItem() {
                    Button("新增账户") {
                        self.showAddAccount.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddAccount, content: {
            addAccount(showAddAccount:self.$showAddAccount)
                .environment(\.managedObjectContext, self.viewContext)
        })
    }
}
