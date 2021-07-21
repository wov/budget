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
    
    @State private var amount: Float
    @State private var name: String
    @State private var basedName: String
//    @State private var basedAmount: Float = 0.0
//    @State private var basedEnd: Date = Date()
//    @State private var basedIsRepeat: Bool = false
//    @State private var basedHasEnd: Bool = false
//
//    enum basedType: String,CaseIterable,Identifiable {
//        case income
//        case expenses
//        var id: String{ self.rawValue }
//    }
//
//    enum basedAmountTypes: String,CaseIterable,Identifiable {
//        case dynamicAmount
//        case fixedAmount
//        var id: String{ self.rawValue}
//    }
//
//    @State private var basedAccountType = basedType.expenses
//    @State private var basedAmountType = basedAmountTypes.fixedAmount
//
    
    init(_ showModifyIE: Binding<Bool>, _ ie: CreatedIE , _ basedie: BasedIE?) {
        self._showModifyIE = showModifyIE
        self.ie = ie
        self.basedie = basedie
        
        self.amount = ie.amount
        self.name = ie.name ?? ""
        self.basedName = basedie?.name ?? ""
        
    }
    
    private func modify(){
        ie.amount = amount
        do {
            self.showModifyIE = false
            try viewContext.save()
        } catch {
            
        }
    }
    
    private func getBasedIE(id:UUID) -> [BasedIE]{
        var bies:[BasedIE] = []
        do {
            let request:NSFetchRequest<BasedIE> = BasedIE.fetchRequest()
            request.predicate =  NSPredicate(format: "id == %@", id as CVarArg)
            bies = try viewContext.fetch(request) as [BasedIE]
        } catch let error as NSError {
            print("Error in fetch :\(error)")
        }
        return bies
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
                Section(header: Text("修改本次")){
                    HStack{
                        Text("名称")
                        TextField("",text:$name)
                    }
                    HStack {
                        Text("金额")
                        TextField("",text:amountBinding)
                            .keyboardType(.decimalPad)
                    }
                }
                
                if((self.basedie) != nil){
//                    let basedies = self.getBasedIE(id:ie.basedie!)
                    Section(header: Text("修改基础")){
                        HStack{
                            Text("名称")
                            TextField("",text:$basedName)
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
