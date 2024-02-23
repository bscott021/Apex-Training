//
//  HomeView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    let user = UserService.shared.user
    
    @EnvironmentObject var model:ApexTrainingModel
    @EnvironmentObject var readyTemplatesModel:ReadyTemplatesModel
    @EnvironmentObject var currentProgram:ProgramModel
    
    @State var currentWorkout = Workout()
    
    @State var showingProgramTemplateView = false
    @State var showSettings = false
    @State var showProfile = false
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                // Show "Ready Programs" if there is not a current program for the user (no program id)
                if user.currentProgramId == "" {
                    ReadyProgramView().environmentObject(self.readyTemplatesModel)
                }
                // Show Workout View (Current or Next)
                else {
                    WorkoutView(currentWorkout: self.currentWorkout).environmentObject(self.currentProgram)
                }
                
            }
            .navigationViewStyle(.stack)
            .navigationBarTitle(Constants.home, displayMode: .inline)
            .toolbar {
                ToolBarView(showSettings: $showSettings, showProfile: $showProfile)
            }
            
        }
        .onAppear {
            self.readyTemplatesModel.getReadyPrograms()
            
            // Check current workout to see if it has values. This is what's passed back and forth between this view and the workut view
            if currentWorkout.id == "" || currentWorkout.workoutName == "" {
                self.currentWorkout = ProgramService.shared.getWorkout(workoutDocIdToGet: user.currentWorkoutId)
            }
            
        }
        
    }
    
}

/*
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
*/
