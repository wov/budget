//
//  modifyCreatedIE.swift
//  budget
//
//  Created by wov on 2021/7/11.
//
import SwiftUI
import CoreData

struct modifyCreatedIE: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showModifyIE: Bool
    
    var ie:CreatedIE
    var basedie:BasedIE?
    
    @State var amount: Float
    @State var name: String
    @State var accountType: String
    
    private func modify(){
        ie.name = name
        ie.amount = amount
        ie.type = accountType
        
        if(basedie != nil){
            basedie?.name = name
            if(basedie?.amounttype == "fixedAmount"){
                basedie?.baseamount = amount
                basedie?.type = accountType
            }
        }
        do {
            self.showModifyIE = false
            try viewContext.save()
        } catch {
            
        }
    }
    
    var body: some View {
        let amountBinding = Binding<String>(get: {
            self.amount == 0 ?
                "" :
                String(self.amount.clean)
        }, set: {
            self.amount = Float($0) ?? 0
        })
        
        NavigationView{
            Form{
                Section{
                    HStack{
                        Text("名称")
                        TextField("",text:$name)
                    }

                    HStack {
                        Text("金额")
                        TextField("",text:amountBinding)
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("类型",selection : $accountType){
                        Text("收入").tag("income")
                        Text("支出").tag("expenses")
                    }
                }
            }
            .navigationBarTitle(ie.name!, displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.showModifyIE = false
                                    }, label: {
                                        Text("取消")
                                    }),trailing:
                                        Button(action: {
                                            self.modify()
                                        }, label: {
                                            Text("确认修改")
                                                .disabled(amount.isZero || amount<0)
                                        })
            )
            
            
        }
        
        
    }
}
