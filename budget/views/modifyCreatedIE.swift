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
//    @State private var title: String
//
//    enum changeTypes: String,CaseIterable,Identifiable {
//        case onlyOnce
//        case onlyNew
//        case changeAll
//        var id: String{ self.rawValue}
//    }
//    @State private var changeType = changeTypes.onlyOnce
    
    
    enum type: String,CaseIterable,Identifiable {
        case income
        case expenses
        var id: String{ self.rawValue }
    }
    
    @State private var accountType:type

    
    init(_ showModifyIE: Binding<Bool>, _ ie: CreatedIE , _ basedie: BasedIE?) {
        self._showModifyIE = showModifyIE
        self.ie = ie
        self.basedie = basedie
//        self.title = title
        
        self.amount = ie.amount
        self.name = ie.name ?? ""
        self.basedName = basedie?.name ?? ""
        self.accountType = modifyCreatedIE.type.allCases.filter{$0.rawValue == ie.type}.first!
    }
    
    private func modify(){
        ie.name = name
        ie.type = accountType.rawValue
        ie.amount = amount
        
        if(basedie != nil){
            basedie?.name = name
            if(basedie?.amounttype == "fixedAmount"){
                basedie?.type = accountType.rawValue
                basedie?.amount = amount
            }
        }
        
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
                        Text("收入").tag(type.income)
                        Text("支出").tag(type.expenses)
                    }
                }
                
//                Section(header :Text("历史记录")){
//                    HStack{
//                        Text("名称")
//                        TextField("",text:$name)
//                    }
//                }
                
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
