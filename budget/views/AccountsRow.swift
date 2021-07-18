//
//  AccountsRow.swift
//  budget
//
//  Created by wov on 2021/6/28.
//

import SwiftUI

struct AccountsRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var account : Account
    var period: Period
    //    TODO: 这里是否需要改成和account关联的ie呢？
    var ies : FetchedResults<CreatedIE>
    
    @FetchRequest(
        entity: BasedIE.entity(),
        sortDescriptors: [],
        animation: .default
    ) var basedies: FetchedResults<BasedIE>
    
    @State private var showAddIE: Bool = false
    @State private var showModifyIE: Bool = false
    
    
    private func deleteIes(offsets: IndexSet){
        offsets.map{ ies[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    
    
    private func getSubTitle(ie:CreatedIE) -> String{
        
        //        let basedie = basedies.first(where: {$0.id == ie.basedie})
        
        let bies = basedies.filter { $0.id == ie.basedie }
        var subTitle:String = ""
        
        if(!bies.isEmpty){
            let bie = bies.first
            if(bie?.amounttype == "dynamicAmount"){
                subTitle += "动态"
            }
            if(bie?.amounttype == "fixedAmount"){
                subTitle += "固定"
            }
        }

        if(ie.type == "income"){
            subTitle += "收入"
        }
        
        if(ie.type == "expenses"){
            subTitle += "支出"
        }
        
        return subTitle
    }
    
    
    
    var body: some View {
        Section(header: Text(account.name ?? "")){
            
            ForEach(self.ies){ ie in
                if(ie.account == account.id){
                    let subTitle = getSubTitle(ie:ie)
                    HStack{
                        VStack(alignment: .leading){
                            Text(subTitle)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
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
                                .environment(\.managedObjectContext, self.viewContext)
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
                        addIE(showAddIE:self.$showAddIE, period: period, account: account)
                            .environment(\.managedObjectContext, self.viewContext)
                    })
                }
            }
            
        }
    }
}
