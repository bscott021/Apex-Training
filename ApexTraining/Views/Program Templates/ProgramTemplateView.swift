//
//  ProgramTemplateView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/18/23.
//

import SwiftUI

struct ProgramTemplateView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @ObservedObject var programTemplateModel:ProgramTemplateModel
    
    @State var showingNewWorkoutTempalteView = false
    
    @State var programName = ""
    @State var programDescription = ""
    @State var numberOfWeeks = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                    
                Text(Constants.editProgramText)
                    .font(.title2)
                
                // Form to enter the program template high level data
                Form {
                    TextField(Constants.nameText, text: $programName)
                    TextField(Constants.descriptionText, text: $programDescription)
                    TextField(Constants.numWeeksText, text: $numberOfWeeks)
                }
                .onAppear {
                    // Assign state properties to retrieved properites
                    programName = programTemplateModel.programTemplate.programName
                    programDescription = programTemplateModel.programTemplate.programDescription
                    numberOfWeeks = programTemplateModel.programTemplate.numCycles
                }
                
                
                // Edit the Workout Templates for this Program Template
                Text(Constants.workoutsText)
                    .font(.title2)
                
                // Link to "Create a Workout"
                ZStack {
                    Rectangle()
                        .frame(height: 40)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                        .padding(20)
                    
                    // Button to create a new WorkoutTemplate
                    VStack {
                        NavigationLink(destination: WorkoutTemplateView(workoutTemplateModel: WorkoutTemplateModel(programTemplateDocId: programTemplateModel.programTemplate.id)), isActive: $showingNewWorkoutTempalteView) { EmptyView() }
                        Button(Constants.addWorkoutText) {
                            self.showingNewWorkoutTempalteView = true
                            programTemplateModel.saveProgramTemplate(saveDB: true, name: programName, description: programDescription, numWeeks: numberOfWeeks)
                        }
                        .foregroundColor(.white)
                    }
                }
                
                
                // Workout Template List
                List (programTemplateModel.workoutTemplates) { wt in
                    VStack {
                        NavigationLink(destination: WorkoutTemplateView(workoutTemplateModel: WorkoutTemplateModel(programTemplateDocId: programTemplateModel.programTemplate.id, workoutTemplate: wt))) {
                            Text(wt.workoutName)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            programTemplateModel.deleteWorkoutTemplate(workoutTemplateToDelete: wt)
                        } label: {
                            Label(Constants.deleteText, systemImage: Constants.deleteImage)
                        }
                        .tint(.red)
                    }
                }
                .onAppear {
                    programTemplateModel.getWorkoutTemplates()
                }
                
                Spacer()
                
                
            }
            
            
        }
        .navigationBarTitle(Constants.editProgramText)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
            _ in
            programTemplateModel.saveProgramTemplate(saveDB: true, name: programName, description: programDescription, numWeeks: numberOfWeeks)
        }
        
    }
    
    
}

/*
struct ProgramTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramTemplateView()
    }
}
*/
