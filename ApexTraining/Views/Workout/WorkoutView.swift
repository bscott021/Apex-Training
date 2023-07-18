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
    
    @State var currentExerciseId:String = ""
    @State var numRepsField:String = ""
    @State var weightEntered:String = ""
    @State var editReps:Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // Exercise Picker
            Picker(
                selection: $currentExerciseId,
                content: {
                    ForEach(currentWorkoutModel.workout.exercises) { e in
                        HStack {
                            Text("\(e.exerciseName) - \(currentWorkoutModel.countCompletedSets(exercise: e))/\(e.numSets)")
                            if Int(currentWorkoutModel.countCompletedSets(exercise: e)) == e.numSets {
                                Image(systemName: Constants.completedIndicator)
                            }
                        }
                    }
                }, label: { EmptyView() })
            .pickerStyle(MenuPickerStyle())
            .onChange(of: currentExerciseId) { selectedExercisesId in
                // Save Exercise
                currentWorkoutModel.saveExercise(exercise: currentWorkoutModel.currentExercise)
                // Refresh the current exercise
                currentWorkoutModel.setCurrentExercise(exerciseId: selectedExercisesId)
                currentExerciseId = currentWorkoutModel.currentExercise.id
                
                currentWorkout = currentWorkoutModel.workout
            }
            
            // Header Row
            HStack {
                Text(Constants.setText)
                Text(Constants.repsText)
                Text(Constants.weightText)
                Spacer()
                Button {
                    editReps.toggle()
                } label: {
                    Label(Constants.editSetText, systemImage: Constants.editImage)
                }
            }
            // List of Sets
            List(currentWorkoutModel.currentExercise.sets) { s in
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
                        TextField(String(s.numReps), value: setNumRepsBinding(for: s), formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Image(systemName: Constants.setRepSpacer)
                    // Weight performed for the set
                    TextField(String(s.weight), value: setWeightBinding(for: s), formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .listStyle(PlainListStyle())
            
            
        }
        .navigationBarTitle(currentWorkoutModel.workout.workoutName)
        .padding(.horizontal)
        .onAppear {
            currentWorkoutModel.setCurrentExercise(exerciseId: currentWorkoutModel.workout.exercises.first?.id  ?? "")
            currentExerciseId = currentWorkoutModel.currentExercise.id
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
            _ in
            currentWorkoutModel.saveExercise(exercise: currentWorkoutModel.currentExercise)
            currentWorkout = currentWorkoutModel.workout
        }
        
    }
    
    private func setNumRepsBinding(for set: Set) -> Binding<Int> {
        guard let index = currentWorkoutModel.currentExercise.sets.firstIndex(where: { $0.id == set.id }) else {
            fatalError("\(Constants.customeErrorTextPrefix): Set not found in func setNumRepsBinding")
        }
        return $currentWorkoutModel.currentExercise.sets[index].numReps
    }
    
    private func setWeightBinding(for set: Set) -> Binding<Int> {
        guard let index = currentWorkoutModel.currentExercise.sets.firstIndex(where: { $0.id == set.id }) else {
            fatalError("\(Constants.customeErrorTextPrefix): Set not found in func setWeightBinding")
        }
        return $currentWorkoutModel.currentExercise.sets[index].weight
    }
    
}

/*
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout())
    }
}
*/
