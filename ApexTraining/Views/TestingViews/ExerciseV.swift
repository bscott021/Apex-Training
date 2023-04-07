//
//  ContentView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/1/23.
//

import SwiftUI

struct ExerciseV: View {
    
    @ObservedObject var exerciseVM = ExerciseVM()
    
    @State var exerciseName = ""
    
    var body: some View {
        
        VStack {
            List (exerciseVM.exerciseList) { exercise in
                HStack {
                    Text(exercise.exerciseName)
                    Spacer()
                    // Update Button
                    Button(action: {
                        // Update Exercise
                        exerciseVM.updateExercise(exerciseToUpdate: exercise)
                    }, label: {
                        Image(systemName: "pencil")
                    })
                    // Delete Button
                    /*
                    Button(action: {
                        // Delete Exercise
                        exerciseVM.deleteExercise(exerciseToDelete: exercise)
                    }, label: {
                        Image(systemName: "minus.circle")
                    })
                    */
                }
            }
            Divider()
            VStack() {
                TextField("Exercise Name", text: $exerciseName)
                Button(action: {
                    // Call addExercise()
                    exerciseVM.addExercise(exerciseName: exerciseName)
                    // Clear text fields
                    exerciseName = ""
                }, label: {
                    Text("Add Exercise")
                })
            }
            .padding()
        }
        
    }
    
    init() {
        exerciseVM.getExercises()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseV()
    }
}
