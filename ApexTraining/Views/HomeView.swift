//
//  HomeView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    
    var body: some View {
        
        VStack {
            Text("Home View")
            
            //TODO: Find a better spot for this
            Button {
                try! Auth.auth().signOut()
                model.checkSignIn()
            } label: {
                Text(Constants.signOut)
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
