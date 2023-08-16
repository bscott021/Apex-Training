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
    
    init() {
    }
    
    init(workoutIn: Workout) {
        self.workout = workoutIn
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
            
            if exercise.status != Constants.skippedExerciseStatus {
                if Int(self.countCompletedSets(exercise: exercise)) == exercise.numSets {
                    exercise.status = Constants.completedExerciseStatus
                } else {
                    exercise.status = Constants.inProgressExerciseStatus
                }
            }
            
            // Save a status of the exercise
            db.collection(Constants.exercisesCollection).document(exercise.id).setData([
                "status": exercise.status
            ], merge: true)
            
        }
        
    }
    
    
    // Set Current Exercises
    func getCurrentExercise(exerciseId: String) -> ExerciseSet {
        // Loop through exercises to look for the correct one
        for e in workout.exercises {
            if e.id == exerciseId {
                return e
            }
        }
        return ExerciseSet()
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

