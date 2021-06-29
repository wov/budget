//
//  ContentView.swift
//  IMS
//
//  Created by wov on 2021/2/12.
//

import SwiftUI

struct ContentView: View {
//    @StateObject var notificationCenter = NotificationCenter()
//    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    @State private var selection: Tab = .list
    
    enum Tab{
        case list
        case setting
    }
    
    
    var body: some View {
        
        TabView(selection: $selection){
//            WareHouse()
            
            AccountsRow()
            
//            GoodList()
//                .tabItem {
//                    Label("我的商品",systemImage:"list.dash")
//                }
//                .tag(Tab.list)
//
//            Setting()
//                .tabItem {
//                    Label("设置",systemImage:"gearshape.fill")
//                }
//                .tag(Tab.setting)
            
            
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}


