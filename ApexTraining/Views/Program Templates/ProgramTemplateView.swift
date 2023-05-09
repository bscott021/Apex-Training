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
    @State var programTemplateStatus: Constants.programTemplateStatus = .Started
    @State var statusToggleEnabled = true
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(Constants.editProgramText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Toggle(isOn: Binding(
                        get: { self.programTemplateStatus == .Ready },
                        set: { self.programTemplateStatus = $0 ? .Ready : .Started }
                        )) {
                        Text(Constants.markReadyText)
                    }
                    .padding(20)
                    .onChange(of: programTemplateStatus) { newValue in
                        // If the new value is Ready then check to make sure it's a valid program template
                        if newValue == .Ready {
                            let valid = programTemplateModel.checkValid(programName: programTemplateModel.programTemplate.programName)
                            // If it is not a valid program template then turn the switch back
                            if valid == false {
                                self.programTemplateStatus = .Started
                            }
                        }
                    }
                    .disabled(!statusToggleEnabled)
                }
                
                
                // Form to enter the program template high level data
                List {
                    HStack {
                        Text(Constants.nameLabel)
                        TextField(Constants.nameText, text: $programName)
                    }
                    HStack {
                        Text(Constants.descriptionLabel)
                        TextField(Constants.descriptionText, text: $programDescription)
                    }
                    HStack {
                        Text(Constants.numWeeksLabel)
                        TextField(Constants.numWeeksText, text: $numberOfWeeks)
                    }
                }
                .listStyle(PlainListStyle())
                
                
                HStack {
                    // Edit the Workout Templates for this Program Template
                    Text(Constants.workoutsText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    Spacer()
                        
                    // Button to create a new WorkoutTemplate
                    VStack {
                        NavigationLink(destination: WorkoutTemplateView(workoutTemplateModel: WorkoutTemplateModel(programTemplateDocId: programTemplateModel.programTemplate.id)), isActive: $showingNewWorkoutTempalteView) { EmptyView() }
                        Button(Constants.addWorkoutText) {
                            self.showingNewWorkoutTempalteView = true
                            programTemplateModel.saveProgramTemplate(saveDB: true, name: programName, description: programDescription, numWeeks: numberOfWeeks, status: programTemplateStatus.stringValue)
                        }
                    }
                }
                .padding(.horizontal)
                
                
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
                .listStyle(PlainListStyle())
                
                Spacer()
                
                
            }
            .onAppear {
                // Assign state properties to retrieved properites
                programName = programTemplateModel.programTemplate.programName
                programDescription = programTemplateModel.programTemplate.programDescription
                numberOfWeeks = programTemplateModel.programTemplate.numCycles
                if programTemplateModel.programTemplate.status == "Ready" {
                    programTemplateStatus = .Ready
                }
                else {
                    programTemplateStatus = .Started
                }
            }
            
        }
        .navigationBarTitle(Constants.editProgramText)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
            _ in
            programTemplateModel.saveProgramTemplate(saveDB: true, name: programName, description: programDescription, numWeeks: numberOfWeeks, status: programTemplateStatus.stringValue)
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
