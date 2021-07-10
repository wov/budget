//
//  addIE.swift
//  budget
//
//  Created by wov on 2021/7/10.
//

import SwiftUI

struct addIE: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showAddIE: Bool
    
    let account:Account

    @State private var name: String = ""
    @State private var amount: Float = 0.0
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    @State private var isrepeat: Bool = false
    
    private func addIE(){
        let newBasedIE = BasedIE(context: viewContext)
//        newAccount.name = accountName
//        newAccount.desc = accountDesc
//        newAccount.id = UUID()
        
        do {
            try viewContext.save()
            self.showAddIE = false
        } catch {
            // Error handling
        }
        
    }
    
    
    var body: some View {
        
        let amountBinding = Binding<String>(get: {
            self.amount == 0 ?
                "" :
                String(self.amount)
        }, set: {
            self.amount = Float($0) ?? 0
        })
        
        
        
        NavigationView{
            Form{
                Section{
                    HStack {
                        Text("名称")
                        TextField("",text:$name)
                    }
                    
                    HStack {
                        Text("金额")
                        TextField("",text:amountBinding)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Toggle("是否需要重复",isOn: $isrepeat)
                    }
                    
                    if(self.isrepeat){
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }.navigationBarTitle("添加收入/支出", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.showAddIE = false
                                    }, label: {
                                        Text("取消")
                                    }), trailing:
                                        Button(action: {
                                            self.addIE()
                                        }, label: {
                                            Text("保存")
                                        })
            )
        }
        
    }
}

//struct addIE_Previews: PreviewProvider {
//    static var previews: some View {
//        addIE()
//    }
//}
