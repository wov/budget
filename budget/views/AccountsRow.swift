//
//  AccountsRow.swift
//  budget
//
//  Created by wov on 2021/6/28.
//

import SwiftUI

struct AccountsRow: View {
    
    var account : Account
    var ies : FetchedResults<BasedIE>
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAddIE: Bool = false
    
    
    private func deleteIes(offsets: IndexSet){
        offsets.map{ ies[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            
        }
    }
    

    var body: some View {
        Section(header: Text(account.name ?? "")){
            
            ForEach(self.ies){ ie in
                if(ie.account == account.id){
                    HStack{
                        VStack(alignment: .leading){
                            Text(ie.name!)
                        }
                        Spacer()
                        Text("\(ie.amonut.clean)")
                    }
                    
                }
            }.onDelete(perform: deleteIes)
            

            HStack{
                VStack(alignment: .leading){
                    Button( action: {
                        self.showAddIE.toggle()
                    }){
                        Text("新增收入/支出")
                    }.sheet(isPresented: $showAddIE, content: {
                        addIE(showAddIE:self.$showAddIE, account:account)
                    })
                }
            }

        }
    }
}

//struct AccountsRow_Previews: PreviewProvider {
////    static var account = Account(name:"test")
//    static var account = Account()
//
//    static var previews: some View {
//        AccountsRow(account: account)
////            .previewLayout(.fixed(width: 300, height: 200))
//    }
//}
