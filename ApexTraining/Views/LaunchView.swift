//
//  LaunchView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @State var tabSelectionId = TabSelectionId.homeView
    
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
                        Image(systemName: Symbols.templateTabImage)
                        Text(Constants.templates)
                    }
                    .environmentObject(StartedTemplatesModel())
                
                HomeView()
                    .tabItem {
                        Image(systemName: Symbols.homeTabImage)
                        Text(Constants.home)
                    }
                    .tag(TabSelectionId.homeView)
                    .environmentObject(ReadyTemplatesModel())
                    .environmentObject(ProgramModel())
                    .onAppear {
                        UserService.shared.getCurrentProgramInfo()
                    }
                
                HistoryView()
                    .tabItem {
                        Image(systemName: Symbols.historyTabImage)
                        Text(Constants.history)
                    }
                    .tag(TabSelectionId.historyView)
                    .environmentObject(WorkoutHistoryModel())
                    .environmentObject(ProgramHistoryModel())
                
            }
        
        }
        
    }
    
}

/*
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
*/

