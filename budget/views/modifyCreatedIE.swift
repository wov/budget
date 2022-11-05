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
    
    @State private var showingDisableAlert = false
    
    private func modify(){
        ie.name = name
        ie.amount = amount
        ie.type = accountType
        
        if(basedie != nil){
            basedie?.name = name
            basedie?.type = accountType
            if(basedie?.amounttype == "fixedAmount"){
                basedie?.baseamount = amount
            }
        }
        do {
            self.showModifyIE = false
            try viewContext.save()
        } catch {
            
        }
    }
    
    private func setDisabled(){
        if(basedie != nil ){
            basedie?.disabled = true
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
                            .frame(width: 80,  alignment: .leading)

                        TextField("修改名称",text:$name)
                    }
                    
                    HStack {
                        Text("金额")
                            .frame(width: 80,  alignment: .leading)

                        if #available(iOS 15.0, *) {
                            TextField("修改金额",value: $amount, format: .number)
                                .foregroundColor( accountType == "income" ? .red : .green)
                                .keyboardType(.decimalPad)
                        } else {
                            TextField("修改金额",text:amountBinding)
                                .foregroundColor( accountType == "income" ? .red : .green)
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    
                    HStack {
                        Text("类型")
                            .frame(width: 80,  alignment: .leading)

                        Picker("类型",selection : $accountType){
                            Text("收入").tag("income")
                            Text("支出").tag("expenses")
                        }
                    }.pickerStyle(.segmented)
                    
                
                    
                    if(self.basedie != nil && !self.basedie!.disabled ){
                        HStack {
                            
                            if(self.basedie?.end != nil){
                                Text("\((self.basedie?.end)! , style: .date)截止")
                            }else{
                                Text("无截止日期")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingDisableAlert = true
                            }) {
                                Label("不再生成", systemImage: "nosign")
                            }
                            .alert(isPresented:$showingDisableAlert) {
                                        Alert(
                                            title: Text("确认不再生成了吗？"),
                                            message: Text("该操作不可取消"),
                                            primaryButton: .destructive(Text("确认")) {
                                                self.setDisabled()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                        }
                        
                        
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
