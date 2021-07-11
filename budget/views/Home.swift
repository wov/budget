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
    
    //TODO:管他呢，先把数据全部载入了吧....
    //这里的init实在是搞不懂了...
    @FetchRequest(
        entity: Account.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Account.name, ascending: false)
        ],
        animation: .default
    ) var accounts: FetchedResults<Account>
    
    @FetchRequest(
        entity: CreatedIE.entity(),
        sortDescriptors: [],
        animation: .default
    ) var ies: FetchedResults<CreatedIE>
    
    @FetchRequest(
        entity: Period.entity(),
        sortDescriptors: [
        ],
        animation: .default
    ) var periods: FetchedResults<Period>
    
    @FetchRequest(
        entity: System.entity(),
        sortDescriptors: [],
        animation: .default
    ) var systems: FetchedResults<System>
    
    
    @State private var showAddAccount: Bool = false
    @State private var showAddPeriod: Bool = false
    
    //Temp code for delete period test.
    private func deletePeriods(){
        let period = self.periods[0]
        viewContext.delete(period)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    var body: some View {
        if(periods.isEmpty){
            NavigationView{
                VStack{
                    Text("当前还未创建账期")
                    Button(action: {
                        self.showAddPeriod.toggle()
                    }){
                        Text("创建账期")
                    }
                }
            }
            .sheet(isPresented: $showAddPeriod, content: {
                addPeriod(showAddPeriod:self.$showAddPeriod)
            })
        }else{
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
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
