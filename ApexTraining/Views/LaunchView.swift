//
//  LaunchView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @State var tabSelectionId = Constants.tabSelectionId.homeView
    
    var body: some View {
        
        if model.signedIn == false {
            SignInView()
                .onAppear {
                    model.checkSignIn()
                }
        }
        else {
            TabView(selection: $tabSelectionId) {
                
                HomeView()
                    .tabItem {
                        Image(systemName: Constants.homeTabImage)
                        Text(Constants.home)
                    }
                    .tag(Constants.tabSelectionId.homeView)
                
                HistoryView()
                    .tabItem {
                        Image(systemName: Constants.historyTabImage)
                        Text(Constants.history)
                    }
                    .tag(Constants.tabSelectionId.historyView)
                
            }
            // TODO: Get and Save Data Here
            /*.onAppear {
                model.getDatabaseData()
            }*/
            /*.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
                _ in
                model.saveData(writeToDatabase: true)
            }*/
        }
        
    }
    
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
