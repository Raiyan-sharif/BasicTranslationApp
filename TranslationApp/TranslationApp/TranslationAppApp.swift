//
//  TranslationAppApp.swift
//  TranslationApp
//
//  Created by BJIT on 26/5/22.
//

import SwiftUI

@main
struct TranslationAppApp: App {
    
    let persitenceController = PersistenceController.shared
    @StateObject var taskListViewModel = TaskListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persitenceController.container.viewContext)
                .environmentObject(taskListViewModel)
        }
    }
}
