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
    @EnvironmentObject var startedTemplatesModel:StartedTemplatesModel
    @EnvironmentObject var readyTemplatesModel:ReadyTemplatesModel
    @EnvironmentObject var currentProgram:ProgramModel
    
    @State var currentWorktout = Workout()
    @State var showProgram = false
    @State var showWorkout = false
    @State var showingProgramTemplateView = false
    @State var showingNewProgramTemplateView = false
    
    var computedWorkoutName: String {
        if currentWorktout.workoutName == "" {
            return UserService.shared.user.currentWorktoutName
        }
        else {
            return currentWorktout.workoutName
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
                                    ProgramView(program: rp, letUserBegin: true, currentWorkout: $currentWorktout, showProgram: $showProgram, takeUserToWorkout: $showWorkout)
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
                            ProgramView(program: currentProgram.currentProgram, letUserBegin: false, currentWorkout: $currentWorktout, showProgram: $showProgram, takeUserToWorkout: $showWorkout)
                        }
                        .onAppear {
                            if user.currentProgramId != "" {
                                currentProgram.getProgram(programDocIdToGet: user.currentProgramId)
                            }
                        }
                        // View Current Workout Button
                        VStack {
                            NavigationLink(destination: WorkoutView(workout: $currentWorktout).onDisappear {
                                //print("Current Workout: \(currentWorktout.workoutName)")
                                //print("Current Program - Current Workout: \(currentProgram.currentWorkout.workoutName)")
                                //print("User - Current Workout Name: \(user.currentWorktoutName)")
                                self.currentProgram.currentWorkout = self.currentWorktout
                            }, isActive: $showWorkout) { EmptyView() }
                            Button(computedWorkoutName) {
                                // If this is empty look it up from the user value
                                if currentProgram.currentWorkout.id == "" {
                                    self.currentProgram.assignCurrentWorkout()
                                    self.currentWorktout = currentProgram.currentWorkout
                                }
                                // Show Workout View
                                self.showWorkout = true
                            }
                        }
                    }
                    .padding(20)
                }
                
                
                // Edit or Create a Program
                HStack {
                    // Edit Programs
                    Text(Constants.editProgramsText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Link to "Create a Program"
                    VStack {
                        NavigationLink(destination: ProgramTemplateView(programTemplateModel: ProgramTemplateModel()), isActive:$showingNewProgramTemplateView) { EmptyView() }
                        Button(Constants.createProgramText) {
                            self.showingNewProgramTemplateView = true
                        }
                    }
                }
                .padding(.horizontal)
                
                
                // List of "Started Templates"
                List (startedTemplatesModel.startedTemplates) { pt in
                    NavigationLink(destination: ProgramTemplateView(programTemplateModel: ProgramTemplateModel(programTemplateDocId: pt.id))) {
                        VStack(alignment: .leading) {
                            Text(pt.programName)
                                .font(.title2)
                            Text(pt.programDescription)
                                .font(.body)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
            }
            .navigationViewStyle(.stack)
            .navigationTitle(Constants.home)
            .navigationBarItems(trailing:
                // "Sign Out" Button
                Button {
                    try! Auth.auth().signOut()
                    model.checkSignIn()
                } label: {
                    Text(Constants.signOut)
                }
            )
            
        }
        .onAppear {
            self.startedTemplatesModel.getProgramTemplates()
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
