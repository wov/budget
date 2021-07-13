//
//  ContentView.swift
//  IMS
//
//  Created by wov on 2021/2/12.
//

import SwiftUI

struct ContentView: View {    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Period.entity(),
        sortDescriptors: [
        ],
        animation: .default
    ) var periods: FetchedResults<Period>
    
    @FetchRequest(
        entity: System.entity(),
        sortDescriptors: [],
        animation: .default
    ) var systems: FetchedResults<System>
    
    
    private func firstLunch(){
        
        //TODO: 这里需要去重
        let id = UUID()
        let date = Date()
        
        let newPeriod = Period(context: viewContext)
        newPeriod.id = id
        
        let yearformat = DateFormatter()
        yearformat.dateFormat = "yyyy"
        let currentyear = yearformat.string(from: date)

        let monthformat = DateFormatter()
        monthformat.dateFormat = "MM"
        let currentmonth = monthformat.string(from: date)
        
        newPeriod.year = String(currentyear)
        newPeriod.month = String(currentmonth)
        
        if(systems.isEmpty){
            let newSystemitems = System(context: viewContext)
            newSystemitems.currentperiod = id
        }else{
            let system = systems[0]
            system.currentperiod = id
        }
        
        do {
            try viewContext.save()
        } catch {
            // Error handling
        }
    }
    
    var body: some View {
        if(periods.isEmpty){
            NavigationView{
                VStack{
                    Text("正在初始化...")
                    Text("请稍后")
                }
            }.onAppear{
                self.firstLunch()
            }
//            .sheet(isPresented: $showAddPeriod, content: {
//                addPeriod(showAddPeriod:self.$showAddPeriod)
//                    .environment(\.managedObjectContext, self.viewContext)
//            })
            
        }else{
            Home(systems[0].currentperiod!)
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


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
////            .environmentObject(ModelData())
//    }
//}


