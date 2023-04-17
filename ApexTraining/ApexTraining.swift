//
//  ApexTraining.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/1/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct ApexTraining: App {
    
    @State var tabSelectionId = 1
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            
            TabView(selection: $tabSelectionId) {
                
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(1)
                
                HistoryView()
                    .tabItem {
                        Image(systemName: "doc")
                        Text("History")
                    }
                    .tag(2)
                
            }
            
        }
    }
    
}
