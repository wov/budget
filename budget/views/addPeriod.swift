//
//  addPeriod.swift
//  budget
//
//  Created by wov on 2021/7/11.
//

import SwiftUI

struct addPeriod: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showAddPeriod: Bool
//    @State private var date = Date()
    //TODO: 这里需要初始化这些值
    @State private var currentyear:Int = 2021
    @State private var currentmonth:Int = 7
    
    
    @FetchRequest(
        entity: System.entity(),
        sortDescriptors: [],
        animation: .default
    ) var systemitems: FetchedResults<System>
    
    
    private func addPeriod(){
        //TODO: 这里需要去重
        let id = UUID()
        
        let newPeriod = Period(context: viewContext)
        newPeriod.id = id
        newPeriod.year = String(currentyear)
        newPeriod.month = String(currentmonth)
        
        if(systemitems.isEmpty){
            let newSystemitems = System(context: viewContext)
            newSystemitems.currentperiod = id
        }else{
            let system = systemitems[0]
            system.currentperiod = id
        }
        
        do {
            try viewContext.save()
            self.showAddPeriod = false
        } catch {
            // Error handling
        }
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker("年份", selection: $currentyear) {
                        ForEach(2021...2030, id: \.self) {
                            Text(String($0))
                        }
                    }

                    Picker("月份", selection: $currentmonth) {
                        ForEach(1...12, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
            }.navigationBarTitle("创建账期", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.showAddPeriod = false
                                    }, label: {
                                        Text("取消")
                                    }), trailing:
                                        Button(action: {
                                            self.addPeriod()
                                        }, label: {
                                            Text("创建")
                                        })
                                
            )
        }
        
    }
}

