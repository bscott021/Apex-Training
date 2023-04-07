//
//  SetV.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/4/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class SetMV:ObservableObject {
    
    @Published var setList = [Set]()
    
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
