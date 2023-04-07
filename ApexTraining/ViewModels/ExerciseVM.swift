//
//  ViewModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/3/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class ExerciseVM: ObservableObject {
    
    @Published var exerciseList = [Exercise]()
    
    func updateExercise(exerciseToUpdate: Exercise) {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Set the date to update
        // Note that instead of the setData method with merge, the updateData method  can be used. 
        db.collection("exercises").document(exerciseToUpdate.id).setData(["exerciseName": "Updated: \(exerciseToUpdate.exerciseName)"], merge: true) { error in
            // Check for errors
            if error == nil {
                // Get the new data
                self.getExercises()
            }
        }
    }
    
    func deleteExercise(exerciseToDelete: Exercise) {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Specify the document to delete
        db.collection("exercises").document(exerciseToDelete.id).delete() { error in
            // Check for errors
            if error == nil {
                // No errors
                // Update the UI from the main thread
                DispatchQueue.main.async {
                    // Remove the Exercise that was just deleted
                    self.exerciseList.removeAll { exercise in
                        // Check for the Exercise to remove
                        return exercise.id == exerciseToDelete.id
                    }
                }
            }
        }
    }
    
    func addExercise(exerciseName: String) {
        // Get a refrence to the database
        let db = Firestore.firestore()
        // Add a document to a collection
        db.collection("exercises").addDocument(data: ["exerciseName":exerciseName]) { error in
            // Check for errors
            if error == nil {
                // No errors
                self.getExercises()
            }
            else {
                // Handle the error
            }
        }
    }
    
    func getExercises() {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Read exercises documents
        db.collection("exercises").getDocuments { snapshot, error in
            // Check for errors
            if error == nil {
                // No Errors
                if let snapshot = snapshot {
                    // Update the exerciseList property in the main thread
                    DispatchQueue.main.async {
                        // Get all the documents and create exercises
                        self.exerciseList = snapshot.documents.map { e in
                            // Create a Exercise for each document returned
                            return Exercise(id: e.documentID, exerciseName: e["exerciseName"] as? String ?? "")
                        }
                    }
                }
            }
            else {
                // Handle the Error
            }
        }
    }

    
}
