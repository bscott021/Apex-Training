//
//  ExerciseView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 2/10/24.
//

import SwiftUI

struct ExerciseView: View {
    
    let user = UserService.shared.user
    
    @EnvironmentObject var currentWorkoutModel:WorkoutModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var currentWorkout:Workout
    
    @State var currentExercise:ExerciseSet
    @State var currentExerciseId:String = ""
    @State var currentWeight:String = "0"
    
    @State private var repsFieldBindings: [Binding<Int>] = []
    @State private var weightFieldBindings: [Binding<Int>] = []
    
    @State var editReps:Bool = false
    
    @State var highestSet:Int = 0
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            // Header Info
            Group {
                // Exercise Name
                Text(currentExercise.exerciseName)
                
                // Text Labels
                Text("\(currentExercise.numReps) \(Constants.repsText)")
                
                // Custom Divider
                CustomDividerView()
            }
            
            // List of Sets
            List(currentExercise.sets) { s in
                HStack {
                    
                    // Set Number
                    RowNumberView(rowNumber: s.setNum)
                    
                    // Reps
                    if editReps == false {
                        // Display the weight value
                        Text("\(String(s.weight))")
                        // Display the reps value
                        Text("x \(String(s.numReps))")
                    }
                    else {
                        // Weight performed for the set
                        TextField(String(s.weight), value: weightFieldBindings[getSetIndex(setId: s.id)], formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        // Let the user change the value
                        TextField(String(s.weight), value: repsFieldBindings[getSetIndex(setId: s.id)], formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                }
            }
            .listStyle(PlainListStyle())
                
            VStack(alignment: .center) {
                
                // Weight Performed Text Field
                TextField(currentWeight, text: $currentWeight)
                    .font(.title2)
                    .foregroundColor(Color(ApexColors.secondary))
                
                // Divider
                CustomDividerView()
                
                // Submit/Save Button
                Button {
                    // Add a set to the exercise
                    let tempSet:Set = Set()
                    tempSet.setNum = highestSet + 1
                    tempSet.weight = Int(currentWeight) ?? 0
                    tempSet.numReps = currentExercise.numReps
                    currentExercise.sets.append(tempSet)
                    // Reset field
                    highestSet = highestSet + 1
                    currentWeight = "0"
                    // Save Exercise
                    currentWorkoutModel.saveExercise(exercise: currentExercise)
                    // Refresh the current exercise
                    currentWorkout = currentWorkoutModel.workout
                    currentExercise = currentWorkoutModel.getCurrentExercise(exerciseId: currentExercise.id)
                    updateBindings()
                    if currentWorkout.status == "New" {
                        ProgramService.shared.updateWorkoutStatus(workoutDocId: currentWorkout.id, newStatusString: Constants.inProgressStatus)
                        currentWorkoutModel.workout.status = Constants.inProgressStatus
                        currentWorkout.status = Constants.inProgressStatus
                    }
                } label: {
                    ButtonBackground(buttonText: Constants.submitText)
                }
                
                // Edit Sets Button
                if !currentExercise.sets.isEmpty {
                    Button {
                        editReps.toggle()
                    } label: {
                        ButtonBackground(buttonText: Constants.editSetsText)
                    }
                }
                
                // Complete Exercise Button
                if (currentExercise.status == Constants.completedWorkoutStatus) {
                    Button {
                        currentWorkoutModel.saveExercise(exercise: currentExercise)
                        // Set exercise in bind variable so it's updated for ui
                        currentWorkout.exercises.first { e in
                            if e.id == currentExerciseId {
                                return true
                            }
                            return false
                        }?.status = Constants.completedStatus
                        // Navigate back to Home
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ButtonBackground(buttonText: "Complete")
                    }
                }
                
            }
            
        }
        .navigationBarTitle(currentWorkoutModel.workout.workoutName)
        .foregroundColor(Color(ApexColors.primary))
        .padding(.horizontal)
        .onAppear {
            currentExerciseId = currentExercise.id
            updateBindings()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
            _ in
            currentWorkoutModel.saveExercise(exercise: currentExercise)
            currentWorkout = currentWorkoutModel.workout
        }
        
    }
    
    private func updateBindings() {
        // Update Bindings for Reps
        repsFieldBindings = currentExercise.sets.map { obj in
            Binding<Int>(
                get: { obj.numReps },
                set: { newValue in
                    if let index = currentExercise.sets.firstIndex(where: { $0.id == obj.id }) {
                        currentExercise.sets[index].numReps = newValue
                    }
                }
            )
        }
        // Update Bindings for Weight Used
        weightFieldBindings = currentExercise.sets.map { obj in
            Binding<Int>(
                get: { obj.weight },
                set: { newValue in
                    if let index = currentExercise.sets.firstIndex(where: { $0.id == obj.id }) {
                        currentExercise.sets[index].weight = newValue
                    }
                }
            )
        }
    }
    
    // Get the index for a setId to match up with the binding
    private func getSetIndex(setId: String) -> Int {
        if let index = currentExercise.sets.firstIndex(where: { $0.id == setId}) {
            return index
        }
        return 0
    }
    
}

/*
 #Preview {
 ExerciseView()
 }
 */
