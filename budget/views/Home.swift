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
    
//    temp func to add a period for test
    private func addPeriod(){
        let year:String = "2021"
        let month:String = "08"
                
        let id = UUID()
        
        let newPeriod = Period(context: viewContext)

        newPeriod.year = year
        newPeriod.month = month
        newPeriod.id = id
    
        for basedie in basedies {
            let newCreatedIe = CreatedIE(context:viewContext)
            newCreatedIe.account = basedie.account
            if(basedie.amounttype == "fixedAmount"){
                newCreatedIe.amount = basedie.amount
            }else{
                newCreatedIe.amount = 0
            }
            newCreatedIe.basedie = basedie.id
            newCreatedIe.id = UUID()
            newCreatedIe.name = basedie.name
            newCreatedIe.period = id
            newCreatedIe.type = basedie.type
        }
        
        do {
            try viewContext.save()
        } catch {
            // Error handling
        }
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
                    HStack{
                        Button("创建月"){
                            self.addPeriod()
                        }
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
