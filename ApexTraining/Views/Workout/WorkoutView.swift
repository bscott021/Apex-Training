//
//  WorkoutView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/16/23.
//

import SwiftUI

struct WorkoutView: View {
    
    let user = UserService.shared.user
    
    @EnvironmentObject var currentWorkoutModel:WorkoutModel
    
    // Biding that allows the workout to be passed back to the parent view
    @Binding var currentWorkout:Workout
    @Binding var showWorkout:Bool
    @Binding var workoutCompleted:Bool
    
    @State var currentExerciseId:String = ""
    @State var currentExercise:ExerciseSet = ExerciseSet()
    
    @State private var repsFieldBindings: [Binding<Int>] = []
    @State private var weightFieldBindings: [Binding<Int>] = []
    
    @State var editReps:Bool = false
    @State var skipExercise = false
    
    var computedSkipButtonText: String {
        if skipExercise == false {
            return Constants.skipText
        }
        else {
            return Constants.resumeText
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Button(Constants.completeWorkoutText) {
                // Ensure current exercises is saved
                currentWorkoutModel.saveExercise(exercise: currentExercise)
                // Complete the workout
                UserService.shared.completeWorkout(workoutDocId: currentWorkout.id, workoutName: currentWorkout.workoutName)
                // Navigate back
                workoutCompleted = true
                showWorkout = false
            }
            
            // Exercise Picker
            Picker(
                selection: $currentExerciseId,
                content: {
                    ForEach(currentWorkout.exercises) { e in
                        HStack {
                            Text("\(e.exerciseName) - \(currentWorkoutModel.countCompletedSets(exercise: e))/\(e.numSets)")
                            if Int(currentWorkoutModel.countCompletedSets(exercise: e)) == e.numSets {
                                Image(systemName: Constants.completedIndicator)
                            }
                            if e.status == Constants.skippedExerciseStatus {
                                Image(systemName: Constants.skippedIndicator)
                            }
                        }
                    }
                }, label: { EmptyView() })
            .pickerStyle(MenuPickerStyle())
            .onChange(of: currentExerciseId) { selectedExercisesId in
                // Save Exercise
                currentWorkoutModel.saveExercise(exercise: currentExercise)
                // Refresh the current exercise
                currentWorkout = currentWorkoutModel.workout
                currentExercise = currentWorkoutModel.getCurrentExercise(exerciseId: selectedExercisesId)
                updateBindings()
                // Set the Skip Status UI for the new exercise
                if currentExercise.status == Constants.skippedExerciseStatus {
                    skipExercise = true
                } else {
                    skipExercise = false
                }
            }
            
            // Header Row
            HStack {
                // Text Labels
                Text(Constants.setText)
                Text(Constants.repsText)
                Text(Constants.weightText)
                Spacer()
                // Skip Button
                if Int(currentWorkoutModel.countCompletedSets(exercise: currentExercise)) ?? 0 < currentExercise.numSets {
                    Button {
                        if skipExercise == false {
                            // Skip
                            currentExercise.status = Constants.skippedExerciseStatus
                        } else {
                            // Resume Exercise
                            currentExercise.status = Constants.inProgressExerciseStatus
                        }
                        // Toggle skip exercise state value
                        skipExercise.toggle()
                    } label: {
                        Label(computedSkipButtonText, systemImage: Constants.skippedIndicator)
                    }
                }
                // Edit Sets Button
                Button {
                    editReps.toggle()
                } label: {
                    Label(Constants.editSetsText, systemImage: Constants.editImage)
                }
            }
            // List of Sets
            List(currentExercise.sets) { s in
                HStack {
                    // Set Number
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 30, height: 30)
                        Text(String(s.setNum))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    if editReps == false {
                        // Display the value
                        Text(String(s.numReps))
                    }
                    else {
                        // Let the user change the value
                        TextField(String(s.weight), value: repsFieldBindings[getSetIndex(setId: s.id)], formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(skipExercise)
                    }
                    Image(systemName: Constants.setRepSpacer)
                    // Weight performed for the set
                    TextField(String(s.weight), value: weightFieldBindings[getSetIndex(setId: s.id)], formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(skipExercise)
                }
            }
            .listStyle(PlainListStyle())
            
            
        }
        .navigationBarTitle(currentWorkoutModel.workout.workoutName)
        .padding(.horizontal)
        .onAppear {
            currentExercise = currentWorkoutModel.getCurrentExercise(exerciseId: currentWorkoutModel.workout.exercises.first?.id  ?? "")
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
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout())
    }
}
*/
