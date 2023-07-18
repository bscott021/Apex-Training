//
//  WorkoutModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 6/1/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Foundation

class WorkoutModel: ObservableObject {
    
    @Published var workout = Workout()
    @Published var currentExercise = ExerciseSet()
    
    init() {
    }
    
    init(workoutIn: Workout) {
        self.workout = workoutIn
        self.setCurrentExercise(exerciseId: workoutIn.exercises.first?.id ?? "")
    }
    
    // Update Set (Number of Reps and Weight)
    func saveExercise(exercise: ExerciseSet) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        if exercise.id != "" {
            let ref = db.collection(Constants.exercisesCollection).document(exercise.id).collection(Constants.setsCollection)
            // Loop through sets and save them to the db
            for s in exercise.sets {
                ref.document(s.id).setData([
                    "numReps": s.numReps,
                    "weight": s.weight
                ], merge: true)
            }
        }
        
    }
    
    
    // Set Current Exercises
    func setCurrentExercise(exerciseId: String) {
        // Loop through exercises to look for the correct one
        for e in workout.exercises {
            if e.id == exerciseId {
                currentExercise = e
                return
            }
        }
    }
    
    
    // Get ExerciseSet Completion
    func countCompletedSets(exercise: ExerciseSet) -> String {
        
        var numCompleted = 0
        
        // Loop through sets and add 1 for ever set completed
        for s in exercise.sets {
            if s.weight > 0 {
                numCompleted += 1
            }
        }
        
        return String(numCompleted)
        
    }
    
    
}

