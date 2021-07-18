//
//  ContentView.swift
//  IMS
//
//  Created by wov on 2021/2/12.
//

import SwiftUI
import CoreData

struct ContentView: View {    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var config: Configure
    
    @FetchRequest(
        entity: Period.entity(),
        sortDescriptors: [
        ],
        animation: .default
    ) var periods: FetchedResults<Period>
    
    
    @FetchRequest(
        entity: BasedIE.entity(),
        sortDescriptors: [
        ],
        animation: .default
    ) var basedies: FetchedResults<BasedIE>
    
    var filteredPeriods: [Period] {
        periods.filter { period in
            (period.year == config.currentDate.year && period.month == config.currentDate.month)
         }
     }
    
    private func createdANewPeriod(){
        let id = UUID()
        let newPeriod = Period(context: viewContext)
        newPeriod.id = id
        newPeriod.year = String(config.currentDate.year)
        newPeriod.month = String(config.currentDate.month)
        
    
        for basedie in basedies {
            let newCreatedIe = CreatedIE(context:viewContext)
            newCreatedIe.account = basedie.account
            if(basedie.amounttype == "fixedAmount"){
                newCreatedIe.amount = basedie.amount
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
            try viewContext.save()
        } catch {
            // Error handling
        }
    }
    
    var body: some View {
        if(filteredPeriods.isEmpty){
            NavigationView{
                VStack{
                    Text("正在初始化...")
                    Text("请稍后")
                }
            }.onAppear{
                self.createdANewPeriod()
            }
        }else{
            Home(filteredPeriods[0].id!)
        }
    }
}


struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
