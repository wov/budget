//
//  modifyCreatedIE.swift
//  budget
//
//  Created by wov on 2021/7/11.
//
import SwiftUI

struct modifyCreatedIE: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var ie:CreatedIE
    @State private var amount: Float
    @Binding var showModifyIE: Bool
    
    init(_ showModifyIE: Binding<Bool>, _ ie: CreatedIE , _ amount: Float ) {
        self._showModifyIE = showModifyIE
        self.ie = ie
        self.amount = amount
    }
    
    private func modify(){
        ie.amount = amount
        do {
            self.showModifyIE = false
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
                        Text("修改金额")
                        TextField("",text:amountBinding)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            .navigationBarTitle(ie.name!, displayMode: .inline)
            .navigationBarItems(trailing:
                                Button(action: {
                                    self.modify()
                                }, label: {
                                    Text("保存")
                                        .disabled(amount.isZero || amount<0)
                                })
            )
            
            
        }

        
    }
}
