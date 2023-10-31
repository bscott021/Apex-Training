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
                
                TemplateView()
                    .tabItem {
                        Image(systemName: Constants.templateTabImage)
                        Text(Constants.templates)
                    }
                    .environmentObject(StartedTemplatesModel())
                
                HomeView()
                    .tabItem {
                        Image(systemName: Constants.homeTabImage)
                        Text(Constants.home)
                    }
                    .tag(Constants.tabSelectionId.homeView)
                    .environmentObject(ReadyTemplatesModel())
                    .environmentObject(ProgramModel())
                    .onAppear {
                        UserService.shared.getCurrentProgramInfo()
                    }
                
                HistoryView()
                    .tabItem {
                        Image(systemName: Constants.historyTabImage)
                        Text(Constants.history)
                    }
                    .tag(Constants.tabSelectionId.historyView)
                    .environmentObject(WorkoutHistoryModel())
                    .environmentObject(ProgramHistoryModel())
                
            }
        
        }
        
    }
    
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
