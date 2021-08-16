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
    @EnvironmentObject var config: Configure
    
    var periodid:UUID
    var currentPeriod : Period
    
    @FetchRequest var accounts : FetchedResults<Account>
    @FetchRequest var ies : FetchedResults<CreatedIE>
    
    @State private var showAddAccount: Bool = false
    
    @State private var income: Float = 0.0
    @State private var expenses: Float = 0.0
    @State private var remind: Float = 0.0

    
    init(_ period:Period ) {
        self.periodid = period.id!
        self.currentPeriod = period
        
        self._accounts = FetchRequest(entity: Account.entity(), sortDescriptors: [])
        self._ies = FetchRequest(entity: CreatedIE.entity(), sortDescriptors: [] ,predicate: NSPredicate(format: "period == %@", periodid as CVarArg))
    }
    
    private func calcRemind() {
        var remind: Float = 0.0
        var income: Float = 0.0
        var expenses: Float = 0.0
        for  ie in self.ies{
            if(ie.type == "income"){
                remind += Float(ie.amount)
                income += Float(ie.amount)
            }else if(ie.type == "expenses"){
                remind -= Float(ie.amount)
                expenses += Float(ie.amount)
            }
        }
//        这里保存本月的收入和结余
        self.income = income
        self.expenses = expenses
        self.remind = remind
        
        self.currentPeriod.income = income
        self.currentPeriod.expenses = expenses
        self.currentPeriod.remind = remind

        do {
            try viewContext.save()
        } catch {

        }
    }
    
    var body: some View {
        VStack {
            List{
//                Section{
//                    HStack{
//                        Text("本月收入")
//                        Spacer()
//                        Text("\(String(format:"%.2f", income))")
//                    }
//                    HStack{
//                        Text("本月支出")
//                        Spacer()
//                        Text("\(String(format:"%.2f", expenses))")
//                    }
//                    HStack{
//                        Text("本月结余")
//                        Spacer()
//                        Text("\(String(format:"%.2f", remind))")
//                    }
//                }
                
                ForEach(accounts) { account in
                    AccountsRow(account:account,period:currentPeriod)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("\(self.currentPeriod.year ?? "")-\(self.currentPeriod.month ?? "")")
            .toolbar{
                ToolbarItem() {
                    Button("新增账户") {
                        self.showAddAccount.toggle()
                    }
                }
            }
            
        }
        .onAppear{
            calcRemind()
        }
        .onDisappear{
            calcRemind()
        }
        .sheet(isPresented: $showAddAccount, content: {
            addAccount(showAddAccount:self.$showAddAccount)
                .environment(\.managedObjectContext, self.viewContext)
        })
    }
}
