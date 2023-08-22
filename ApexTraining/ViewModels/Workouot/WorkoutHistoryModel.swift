//
//  WorkoutHistoryModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 8/20/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Foundation

class WorkoutHistoryModel: ObservableObject {
    
    @Published var completedWorkouts:[Workout]
    
    init() {
        completedWorkouts = [Workout]()
    }
    
    // Get Completed Workouts
    func getCompletedWorkouts() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Look up workouts with status of complete
        db.collection(Constants.workoutCollection).whereField("status", isEqualTo: "Complete").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    self.completedWorkouts = snapshot.documents.map { e in
                        // Set the Workout level data
                        let tempWorkout = Workout()
                        tempWorkout.id = e.documentID
                        tempWorkout.workoutName = e["workoutName"] as? String ?? ""
                        tempWorkout.dateTimeCompleted = e["dateTimeCompleted"] as? Date ?? Date()
                        
                        return tempWorkout
                    }
                }
            }
            else {
                // Handle Error
                print("\(Constants.customeErrorTextPrefix)\(error.debugDescription)")
            }
        }
        
        return
        
    }
    
    
}
