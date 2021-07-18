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
    @FetchRequest var currentPeriod : FetchedResults<Period>
    
    @State private var showAddAccount: Bool = false
    
    @FetchRequest(
        entity: BasedIE.entity(),
        sortDescriptors: [],
        animation: .default
    ) var basedies: FetchedResults<BasedIE>
    
//    TODO:这里改成直接传过来period，而不是传ID
    init(_ periodid:UUID ) {
        self.periodid = periodid
        self._accounts = FetchRequest(entity: Account.entity(), sortDescriptors: [])
        self._ies = FetchRequest(entity: CreatedIE.entity(), sortDescriptors: [] ,predicate: NSPredicate(format: "period == %@", periodid as CVarArg))
        //TODO: 需要考虑到获取不到的情况
        self._currentPeriod = FetchRequest(entity: Period.entity(),  sortDescriptors: [] ,predicate: NSPredicate(format: "id == %@", periodid as CVarArg))
    }
    
    private func calcRemind() -> Float{
        var remind: Float = 0.0
        for  ie in self.ies{
            if(ie.type == "income"){
                remind += ie.amount
            }else if(ie.type == "expenses"){
                remind -= ie.amount
            }
        }
        return remind
    }


    var body: some View {
        let remind:Float = calcRemind()
        NavigationView {
            List{
                Section{
                    HStack{
                        Text("本月结余")
                        Spacer()
                        Text("\(remind.clean)")
                    }
                }
                ForEach(accounts) { account in
                    AccountsRow(account:account,ies:ies)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("\(self.currentPeriod[0].year!)-\(self.currentPeriod[0].month!)")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        HStack() {
                            Image(systemName: "chevron.backward")
                            Text("月份")
                        }
                    }
                };
                ToolbarItem() {
                    Button("管理账户") {
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
