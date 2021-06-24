//
//  budgetApp.swift
//  budget
//
//  Created by wov on 2021/6/24.
//

import SwiftUI

@main
struct budgetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
