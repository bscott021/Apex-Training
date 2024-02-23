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
    
    // MARK: Properties
    
    @Published var workout = Workout()
    
    
    // MARK: Init
    
    /// Blank initializer
    init() {
    }
    
    
    /// Initialize from a passed in workout
    ///
    /// - Parameter workoutIn: Workout object for new instance
    init(workoutIn: Workout) {
        self.workout = workoutIn
    }
    
    
    // MARK: Methods 
    
    /// Save an exercise to the database
    ///
    /// - Parameter exercise: Exercise set object to save
    func saveExercise(exercise: ExerciseSet) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        if exercise.id != "" {
            let ref = db.collection(Collections.exercisesCollection).document(exercise.id).collection(Collections.setsCollection)
            // Loop through sets and save them to the db
            for s in exercise.sets {
                if s.id != "" {
                    ref.document(s.id).setData([
                        "setNum": s.setNum,
                        "numReps": s.numReps,
                        "weight": s.weight
                    ], merge: true)
                }
                else {
                    let newSetDocId = ref.addDocument(data: [
                        "setNum": s.setNum,
                        "numReps": s.numReps,
                        "weight": s.weight
                    ]).documentID
                    
                    s.id = newSetDocId
                }
            }
            
            if Int(self.countCompletedSets(exercise: exercise)) ?? 0 >= exercise.numSets {
                exercise.status = Constants.completedStatus
            } else {
                exercise.status = Constants.inProgressStatus
            }
            
            // Save a status of the exercise
            db.collection(Collections.exercisesCollection).document(exercise.id).setData([
                "status": exercise.status
            ], merge: true)
            
        }
        
    }
    
    
    /// Set Current Exercises
    ///
    /// - Parameter exerciseId: Id of the exercise set object that is wanted
    /// - Returns ExerciseSet: Exercise set for the passed in id
    func getCurrentExercise(exerciseId: String) -> ExerciseSet {
        // Loop through exercises to look for the correct one
        for e in workout.exercises {
            if e.id == exerciseId {
                return e
            }
        }
        return ExerciseSet()
    }
    
    
    /// Get ExerciseSet Completion
    ///
    /// - Parameter exercise: Exercise set object
    /// - Returns String value for the number of sets in a completed status
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
    
    
    // MARK: End 
    
}

