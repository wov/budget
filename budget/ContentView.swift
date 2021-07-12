//
//  ContentView.swift
//  IMS
//
//  Created by wov on 2021/2/12.
//

import SwiftUI

struct ContentView: View {    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAddPeriod: Bool = false
//    @State private var currentPeriod: UUID? = nil
    
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
    
    
    var body: some View {
        
        if(systems.isEmpty){
            
            NavigationView{
                VStack{
                    Text("当前还未创建账期")
                    Button(action: {
                        self.showAddPeriod.toggle()
                    }){
                        Text("创建账期")
                    }
                }
            }
            .sheet(isPresented: $showAddPeriod, content: {
                addPeriod(showAddPeriod:self.$showAddPeriod)
            })
            
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


