//
//  WorkoutTemplateModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/24/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class WorkoutTemplateModel: ObservableObject {
    
    // MARK: Properties
    @Published var programTemplateDocId = ""
    @Published var workoutTemplate = WorkoutTemplate()
    
    // MARK: Init
    // Create blank
    init(programTemplateDocId: String) {
        self.programTemplateDocId = programTemplateDocId
    }
    
    // Passed in from parent
    init(programTemplateDocId: String, workoutTemplate: WorkoutTemplate) {
        self.programTemplateDocId = programTemplateDocId
        self.workoutTemplate = workoutTemplate
    }
    
    // MARK: Methods
    // Get a single Program Template
    func getWorkoutTemplate(programTemplateDocId: String, workoutTemplateDocId: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get Program Template Document
        let db = Firestore.firestore()
        let programTemplateDoc = db.collection(Constants.programTemplateCollection).document(programTemplateDocId)
        let workoutTemplateDoc = programTemplateDoc.collection(Constants.workoutTemplateCollection).document(workoutTemplateDocId)
        workoutTemplateDoc.getDocument { snapshot, error in
            guard error == nil, snapshot != nil else {
                return
            }
            let data = snapshot?.data()
            // Set Workout Template Properties
            self.workoutTemplate.id = workoutTemplateDoc.documentID
            self.workoutTemplate.workoutName = data?["workoutName"] as? String ?? ""
        }
        
    }
    
    
    // Save a Wokrout Template to the View Model and the database if the scenario requires it. If there is already a document, update it. Otherwise create a new document.
    func saveWorkoutTemplate(saveDB: Bool, name: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Assign properites to the model. This could also be done by reusing the get method but I don't know if it's necessary to fetch from the db again
        workoutTemplate.workoutName = name
        
        if saveDB {
            
            let db = Firestore.firestore()
            
            if programTemplateDocId != "" {
                // We have a document id for a Program Template
                
                if workoutTemplate.id != "" {
                    // Update Existing Wokrout Template
                    let workoutTemplateDoc = db.collection(Constants.programTemplateCollection).document(programTemplateDocId).collection(Constants.workoutTemplateCollection).document(workoutTemplate.id)
                    workoutTemplateDoc.setData(["workoutName": name], merge: true)
                }
                else {
                    // Add New Workout Template
                    let ref = db.collection(Constants.programTemplateCollection).document(programTemplateDocId).collection(Constants.workoutTemplateCollection).addDocument(data: ["workoutName": name]) { error in
                        if let e = error {
                            // Error adding program template
                            print("\(Constants.customeErrorTextPrefix)\(e)")
                        }
                    }
                    // Set the id that was just created for the document in the model so it can be used in the view
                    workoutTemplate.id = ref.documentID
                }
                
            }
                
            
        }
        
    }
    
}
