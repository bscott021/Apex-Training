//
//  SetVM.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/4/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class SetVM:ObservableObject {
    
    @Published var setList = [Set]()
    
    func updateSet(setToUpdate: Set) {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Set the date to update
        db.collection("sets").document(setToUpdate.id).setData(["setNum": setToUpdate.setNum + 1, "numReps": setToUpdate.numReps + 1, "weight": setToUpdate.weight + 1], merge: true) { error in
            // Check for errors
            if error == nil {
                // Get the new data
                self.getSets()
            }
        }
    }
    
    func deleteSet(setToDelete: Set) {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Specify the document to delete
        db.collection("sets").document(setToDelete.id).delete() { error in
            // Check for errors
            if error == nil {
                // No errors
                // Update the UI from the main thread
                DispatchQueue.main.async {
                    // Remove the Exercise that was just deleted
                    self.setList.removeAll { setL in
                        // Check for the Exercise to remove
                        return setL.id == setToDelete.id
                    }
                }
            }
        }
    }
    
    func addSet(setNum: Int, numReps: Int, weight: Int) {
        // Get a refrence to the database
        let db = Firestore.firestore()
        // Add a document to a collection
        db.collection("sets").addDocument(data: ["setNum":setNum, "numReps":numReps, "weight":weight]) { error in
            // Check for errors
            if error == nil {
                // No errors
                self.getSets()
            }
            else {
                // Handle the error
            }
        }
    }
    
    func getSets() {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Read exercises documents
        db.collection("sets").getDocuments { snapshot, error in
            // Check for errors
            if error == nil {
                // No Errors
                if let snapshot = snapshot {
                    // Update the exerciseList property in the main thread
                    DispatchQueue.main.async {
                        // Get all the documents and create exercises
                        self.setList = snapshot.documents.map { e in
                            // Create a Exercise for each document returned
                            return Set(id: e.documentID,
                                       setNum: e["setNum"] as? Int ?? 0,
                                       numReps: e["numReps"] as? Int ?? 0,
                                       weight: e["weight"] as? Int ?? 0)
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
