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
            try viewContext.save()
            self.showModifyIE = false
        } catch {
            // Error handling
        }
    }
    
//    private func deleteIe(){
//        viewContext.delete(self.ie)
//        do {
//            try viewContext.save()
//            self.showModifyIE = false
//        } catch {
//
//        }
//    }
    
    
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
                            .keyboardType(.numberPad)
                    }
                }
                
                //TODO: 等iOS 15.0 正式版可以使用buttonRole...，现在不管了
//                Section{
//                    HStack {
//                        Button(
//                            action: {
//                                self.deleteIe()
//                            }){
//                            Text("删除")
//                        }
//                    }
//                }
                
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
