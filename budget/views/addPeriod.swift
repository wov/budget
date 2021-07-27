//
//  addPeriod.swift
//  budget
//
//  Created by wov on 2021/7/27.
//

import SwiftUI
import CoreData

struct addPeriod: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAlert = false
    
    @Binding var showAddPeroid: Bool
    
    @State var year: String
    @State var month: String
    
    @FetchRequest(
        entity: BasedIE.entity(),
        sortDescriptors: [
        ],
        animation: .default
    ) var basedies: FetchedResults<BasedIE>
    
    
    private func createdANewPeriod(){
        let repeatPeriod = self.getPerid(year: self.year, month: self.month)
        if(repeatPeriod != nil){
            self.showingAlert = true
            return
        }
        
        let id = UUID()
        let newPeriod = Period(context: viewContext)
        newPeriod.id = id
        newPeriod.year = self.year
        newPeriod.month = self.month
        
        for basedie in basedies {
//            TODO: 如果basedie中包含了 截止日期，且截止日期小于这个月就不要创建了。
            let newCreatedIe = CreatedIE(context:viewContext)
            newCreatedIe.account = basedie.account
            if(basedie.amounttype == "fixedAmount"){
                newCreatedIe.amount = basedie.baseamount
            }else{
                newCreatedIe.amount = 0
            }
            newCreatedIe.basedie = basedie.id
            newCreatedIe.id = UUID()
            newCreatedIe.name = basedie.name
            newCreatedIe.period = id
            newCreatedIe.type = basedie.type
        }
        do {
            self.showAddPeroid = false
            try viewContext.save()
        } catch {
            // Error handling
        }
    }
    
    
    private func getPerid(year:String,month:String) -> Period?{
        var periods:[Period] = []
        do {
            let request:NSFetchRequest<Period> = Period.fetchRequest()
            request.predicate =  NSPredicate(format: "year == %@ AND month == %@",year,month)
            periods = try viewContext.fetch(request) as [Period]
        } catch let error as NSError {
            print("Error in fetch :\(error)")
        }
        return periods.first
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    HStack {
                        Text("年份")
                        TextField("年份",text:$year)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("月份")
                        TextField("月份",text:$month)
                            .keyboardType(.numberPad)
                    }
                }
            }
            
            .navigationBarTitle("添加月份", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.showAddPeroid = false
                                    }, label: {
                                        Text("取消")
                                    }), trailing:
                                        Button(action: {
                                            self.createdANewPeriod()
                                        }, label: {
                                            Text("保存")
                                        })
            )
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("该账期已存在"), message: Text("请重新填写年月份"), dismissButton: .default(Text("知道了")))
        }
    }
}

//struct addPeriod_Previews: PreviewProvider {
//    static var previews: some View {
//        addPeriod()
//    }
//}
