//
//  ApexTrainingApp.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/1/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct ApexTrainingApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Text("Hello World")
        }
    }
    
}
