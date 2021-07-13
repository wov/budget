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
    
    @FetchRequest(
        entity: System.entity(),
        sortDescriptors: [],
        animation: .default
    ) var systemitems: FetchedResults<System>
    
    let account:Account
    
    @State private var name: String = ""
    @State private var amount: Float = 0.0
    @State private var end: Date = Date()
    @State private var isrepeat: Bool = false
    
    @State private var hasEnd: Bool = false
    
    
    enum type: String,CaseIterable,Identifiable {
        case income
        case expenses
        var id: String{ self.rawValue }
    }
    
    enum amountTypes: String,CaseIterable,Identifiable {
        case dynamicAmount
        case fixedAmount
        var id: String{ self.rawValue}
    }
    
    @State private var accountType = type.expenses
    @State private var amountType = amountTypes.fixedAmount
    
    
    private func addIE(){
        let newCreatedIE = CreatedIE(context: viewContext)
        newCreatedIE.id = UUID()
        newCreatedIE.account = account.id
        newCreatedIE.amount = amount
        newCreatedIE.name = name
        newCreatedIE.type = accountType.rawValue
        
        
        if(isrepeat){
            let newBasedIE = BasedIE(context: viewContext)
            let basedID = UUID()
            
            newBasedIE.id = basedID
            newBasedIE.account = account.id
            newBasedIE.type = accountType.rawValue
            newBasedIE.name = name
            newBasedIE.amount = amount
            newBasedIE.amounttype = amountType.rawValue
    
            newCreatedIE.basedie = basedID
            
            if(hasEnd){
                newBasedIE.end = end
            }
        }
        
        
        if(!systemitems.isEmpty){
            newCreatedIE.period = systemitems[0].currentperiod
        }

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
                String(self.amount.clean)
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
                    
                    Picker("类型",selection : $accountType){
                        Text("收入").tag(type.income)
                        Text("支出").tag(type.expenses)
                    }
                    
                    HStack {
                        Text("金额")
                        TextField("",text:amountBinding)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Toggle("按月重复",isOn: $isrepeat)
                    }
                    
                    if(self.isrepeat){
                        Picker("金额类型",selection : $amountType){
                            Text("每月固定").tag(amountTypes.fixedAmount)
                            Text("每月调整").tag(amountTypes.dynamicAmount)
                        }
                        
                        HStack {
                            Toggle("包含截止日期",isOn: $hasEnd)
                        }
                        
                        if(self.hasEnd){
                            HStack{
                                DatePicker(
                                    "结束时间",
                                    selection : $end,
                                    displayedComponents: [.date]
                                )
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle("\(account.name!)", displayMode: .inline)
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
                                        }).disabled( name.isEmpty || amount.isZero)
                                
            )
        }
        
    }
}
