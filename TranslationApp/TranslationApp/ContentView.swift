//
//  ContentView.swift
//  TranslationApp
//
//  Created by BJIT on 26/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewController
    @EnvironmentObject var taskViewVM: TaskListViewModel
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
