//
//  ToolBarView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 12/14/23.
//

import SwiftUI
import FirebaseAuth

struct ToolBarView: ToolbarContent {
    
    @EnvironmentObject var model:ApexTrainingModel
    
    @Binding var showSettings: Bool
    @Binding var showProfile: Bool
    
    var body: some ToolbarContent {
        
        // Settings
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: Symbols.settingsImage)
                    .foregroundColor(Color(ApexColors.primary))
            }
            .sheet(isPresented: $showSettings) {
                Text("Settings: TODO")
            }
        }
        // Logo
        ToolbarItem(placement: .principal) {
            Image(systemName: Symbols.logoImage)
        }
        // Profile
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showProfile.toggle()
            }) {
                Image(systemName: Symbols.profileImage)
                    .foregroundColor(Color(ApexColors.primary))
            }
            .sheet(isPresented: $showProfile) {
                VStack {
                    Text("Profile: TODO")
                    // "Sign Out" Button
                    Button {
                        try! Auth.auth().signOut()
                        model.checkSignIn()
                    } label: {
                        Text(Constants.signOut)
                    }
                }
            }
        }
    
    }
    
}

