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
    
    
    var filteredPeriods: [Period] {
        periods.filter { period in
            period.id == config.currentPeriod
         }
     }

    var body: some View {
//        if(filteredPeriods.isEmpty){
            PeriodList()
//        }else{
//            Home(filteredPeriods.first!)
//        }
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
