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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            
            LaunchView()
                .environmentObject(ApexTrainingModel())
            
        }
    }
    
}
