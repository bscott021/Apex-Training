//
//  WorkoutTemplateView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/23/23.
//

import SwiftUI

struct WorkoutTemplateView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @ObservedObject var workoutTemplateModel:WorkoutTemplateModel
    
    @State var workoutName = ""
    @State var showAddSheet = false
    @State var showUpdateSheet = false
    
    @State var exerciseName = ""
    @State var numSets = ""
    @State var numReps = ""
    
    @State var currentExerciseSetTemplateId = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                // Workout Title
                Text(Constants.editWorkoutText)
                    .font(.title2)
                
                // Workout Info Form
                Form {
                    TextField(Constants.nameText, text: $workoutName)
                }
                
                // Exercise Set Text
                Text(Constants.exercisesText)
                    .font(.title2)
                
                // Add Exercises
                Button(Constants.addExercisesText) {
                    exerciseName = ""
                    numSets = ""
                    numReps = ""
                    showAddSheet.toggle()
                }
                .sheet(isPresented: $showAddSheet) {
                    VStack {
                        ExerciseSetTemplateView(heading: Constants.addExercisesText, exerciseName: $exerciseName, numSets: $numSets, numReps: $numReps)
                        Button(Constants.submitText) {
                            workoutTemplateModel.addExerciseSetTemplate(saveDB: true, name: exerciseName, numSets: Int(numSets) ?? 0, numReps: Int(numReps) ?? 0)
                            workoutTemplateModel.getExerciseSetTemplates()
                            exerciseName = ""
                            numSets = ""
                            numReps = ""
                        }
                    }
                }
                
                // Exercise Set Template List
                List (workoutTemplateModel.exerciseSetTemplates) { est in
                    Button("\(est.exerciseName) - \(est.numSets) sets") {
                        exerciseName = est.exerciseName
                        numSets = String(est.numSets)
                        numReps = String(est.numReps)
                        showUpdateSheet.toggle()
                    }
                    .sheet(isPresented: $showUpdateSheet) {
                        ExerciseSetTemplateView(heading: Constants.updateExerciseText, exerciseName: $exerciseName, numSets: $numSets, numReps: $numReps)
                        Button(Constants.submitText) {
                            workoutTemplateModel.updateExerciseSetTemplate(exerciseSetTemplateId: est.id, name: exerciseName, numSets: Int(numSets) ?? 0, numReps: Int(numReps) ?? 0)
                            workoutTemplateModel.getExerciseSetTemplates()
                            showUpdateSheet.toggle()
                            exerciseName = ""
                            numSets = ""
                            numReps = ""
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            workoutTemplateModel.deleteExerciseSetTemplate(exerciseSetTemplateToDelete: est)
                        } label: {
                            Label(Constants.deleteText, systemImage: Constants.deleteImage)
                        }
                        .tint(.red)
                    }
                }
                .onAppear {
                    workoutTemplateModel.getExerciseSetTemplates()
                }
                
                Spacer()
                
            }
            
        }
        .navigationTitle(Constants.editWorkoutText)
        .onAppear {
            workoutName = workoutTemplateModel.workoutTemplate.workoutName
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
            _ in
            workoutTemplateModel.saveWorkoutTemplate(saveDB: true, name: workoutName)
        }
        
    }
    
    
}

/*
struct WorkoutTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTemplateView()
    }
}
*/
