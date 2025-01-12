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
    
    @State var showProgram = false
    @State var showWorkout = false
    @State var showingProgramTemplateView = false
    @State var showSettings = false
    @State var showProfile = false
    
    @State var workoutReturnedCompleted = false
    @State var programReturnedCompleted = false
    
    var computedWorkoutName: String {
        if currentWorkout.workoutName == "" {
            return UserService.shared.user.currentWorktoutName
        }
        else {
            return currentWorkout.workoutName
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                // Show "Ready Programs" if there is not a current program for the user (no program id)
                if user.currentProgramId == "" {
                    VStack(alignment: .leading) {
                        // Select Program from "Ready" programs
                        Text(Constants.selectProgramText)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        // List of programs that are in a Ready status
                        List (readyTemplatesModel.readyPrograms) { rp in
                            Button {
                                showProgram.toggle()
                            } label: {
                                Text(rp.programName)
                                    .font(.title2)
                                    .padding(.leading)
                            }
                            .sheet(isPresented: $showProgram) {
                                VStack {
                                    ProgramView(program: rp, letUserBegin: true, currentWorkout: $currentWorkout, showProgram: $showProgram, takeUserToWorkout: $showWorkout, programCompleted: $programReturnedCompleted)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                // Show a button to display the current program
                else {
                    VStack(alignment: .leading) {
                        // View Current Program Button
                        Button(UserService.shared.user.currentProgramName) {
                            showProgram.toggle()
                        }
                        .sheet(isPresented: $showProgram) {
                            ProgramView(program: currentProgram.currentProgram, letUserBegin: false, currentWorkout: $currentWorkout, showProgram: $showProgram, takeUserToWorkout: $showWorkout, programCompleted: $programReturnedCompleted).onDisappear() {
                                if programReturnedCompleted == true {
                                    // Clear the values
                                    currentProgram.currentProgram = Program()
                                    currentWorkout = Workout()
                                    UserService.shared.getCurrentProgramInfo()
                                    user.currentProgramId = ""
                                }
                            }
                        }
                        .onAppear {
                            if user.currentProgramId != "" {
                                currentProgram.getProgram(programDocIdToGet: user.currentProgramId)
                            }
                        }
                        // View Current Workout Button
                        VStack {
                            NavigationLink(destination: WorkoutView(currentWorkout: self.$currentWorkout, showWorkout: $showWorkout, workoutCompleted: $workoutReturnedCompleted).environmentObject(WorkoutModel(workoutIn: self.currentWorkout)).onDisappear() {
                                // When the WorkoutView disappears
                                if workoutReturnedCompleted == true {
                                    currentProgram.getProgram(programDocIdToGet: user.currentProgramId)
                                    // Reset
                                    workoutReturnedCompleted = false
                                }
                                
                            }, isActive: $showWorkout) { EmptyView() }
                            Button(computedWorkoutName) {
                                // Show Workout View
                                self.showWorkout = true
                            }
                        }
                        .onAppear {
                            // Check current workout to see if it has values. This is what's passed back and forth between this view and the workut view
                            if currentWorkout.id == "" || currentWorkout.workoutName == "" {
                                self.currentWorkout = ProgramService.shared.getWorkout(workoutDocIdToGet: user.currentWorkoutId)
                            }
                        }
                    }
                    .padding(20)
                }
                
                Spacer()
                
            }
            .navigationViewStyle(.stack)
            .navigationTitle(Constants.home)
            .toolbar {
                // Settings
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings.toggle()
                        }) {
                            Image(systemName: Symbols.settingsImage)
                                .foregroundColor(.black)
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
                                .foregroundColor(.black)
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
        .onAppear {
            self.readyTemplatesModel.getReadyPrograms()
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
