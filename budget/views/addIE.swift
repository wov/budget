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
    var period:Period
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
    
    
    private func useDateAsName(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM-dd"
        name += format.string(from: date)
    }
    
    private func addIE(){
        let newCreatedIE = CreatedIE(context: viewContext)
        let date = Date()
        newCreatedIE.id = UUID()
        newCreatedIE.account = account.id
        newCreatedIE.amount = amount
        newCreatedIE.name = name
        newCreatedIE.type = accountType.rawValue
        newCreatedIE.date = date
                
        if(isrepeat){
            let newBasedIE = BasedIE(context: viewContext)
            let basedID = UUID()
            
            newBasedIE.id = basedID
            newBasedIE.account = account.id
            newBasedIE.type = accountType.rawValue
            newBasedIE.name = name
            newBasedIE.baseamount = amount
            newBasedIE.amounttype = amountType.rawValue
    
            newCreatedIE.basedie = basedID
            
            if(hasEnd){
                newBasedIE.end = end
            }
        }
        
        newCreatedIE.period = period.id

        do {
            self.showAddIE = false
            try viewContext.save()
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
                        Text("??????")
                            .frame(width: 80,  alignment: .leading)
                        TextField("??????",text:$name)
                    }
                    
                    HStack {
                        Text("??????")
                            .frame(width: 80,  alignment: .leading)

                        Picker("??????",selection : $accountType){
                            Text("??????").tag(type.expenses)
                            Text("??????").tag(type.income)
                        }
                    }.pickerStyle(.segmented)
                    
                    HStack {
                        Text("??????")
                            .frame(width: 80,  alignment: .leading)


                        if #available(iOS 15.0, *) {
                            TextField("??????",value: $amount, format: .currency(code: "CNY"))
                                .foregroundColor( accountType.rawValue == "income" ? .red : .green)
                        } else {
                            TextField("??????",text:amountBinding)
                                .foregroundColor( accountType.rawValue == "income" ? .red : .green)
                        }

                    }
                    
                    HStack {
                        Toggle("????????????",isOn: $isrepeat)
                    }
                    
                    if(self.isrepeat){
                        
                        
                        HStack {
                            Text("????????????")
                                .frame(width: 80,  alignment: .leading)

                            Picker("????????????",selection : $amountType){
                                Text("????????????").tag(amountTypes.fixedAmount)
                                Text("????????????").tag(amountTypes.dynamicAmount)
                            }
                        }.pickerStyle(.segmented)
                        
                        HStack {
                            Toggle("??????????????????",isOn: $hasEnd)
                        }
                        
                        if(self.hasEnd){
                            HStack{
                                DatePicker(
                                    "????????????",
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
                                        Text("??????")
                                    }), trailing:
                                        Button(action: {
                                            self.addIE()
                                        }, label: {
                                            Text("??????")
                                        }).disabled( name.isEmpty || amount.isZero)
                                
            )
        }
        
    }
}
