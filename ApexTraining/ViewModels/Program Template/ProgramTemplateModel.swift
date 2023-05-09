//
//  ProgramTemplateModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/18/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class ProgramTemplateModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var programTemplate = ProgramTemplate()
    @Published var workoutTemplates = [WorkoutTemplate]()
    
    // MARK: Init
    
    // Create New Program Template
    init() {
        // Don't fetch anything
    }
    
    // Load program template by document id
    init(programTemplateDocId: String) {
        // Get an existing document
        getProgramTemplate(docId: programTemplateDocId)
    }
    
    // MARK: Methods
    
    // Get a single Program Template
    func getProgramTemplate(docId: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let doc = db.collection(Constants.programTemplateCollection).document(docId)
        doc.getDocument { snapshot, error in
            guard error == nil, snapshot != nil else {
                return
            }
            let data = snapshot?.data()
            // Set Program Template Properties
            self.programTemplate.id = doc.documentID
            self.programTemplate.programName = data?["programName"] as? String ?? ""
            self.programTemplate.programDescription = data?["programDescription"] as? String ?? ""
            self.programTemplate.numCycles = data?["numCycles"] as? String ?? ""
            self.programTemplate.status = data?["status"] as? String ?? ""
        }
        
    }
    
    // Save a program template to the view model and the database if the scenario requires it. If there is already a document, update it. Otherwise create a new document.
    func saveProgramTemplate(saveDB: Bool, name: String, description: String, numWeeks: String, status: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Assign properites to the model. This could also be done by reusing the get method but I don't know if it's necessary to fetch from the db again
        programTemplate.programName = name
        programTemplate.programDescription = description
        programTemplate.numCycles = numWeeks
        programTemplate.status = status
        
        if saveDB {
            let db = Firestore.firestore()
            // Update an existing Program Template by document id
            if programTemplate.id != "" {
                let doc = db.collection(Constants.programTemplateCollection).document(programTemplate.id)
                doc.setData([
                    "programName": name,
                    "programDescription": description,
                    "numCycles": numWeeks,
                    "status": status
                ], merge: true)
            }
            // Create a new Program Template in the db
            else {
                let ref = db.collection(Constants.programTemplateCollection).addDocument(data: [
                    "programName": name,
                    "programDescription": description,
                    "numCycles": numWeeks,
                    "status": status
                ]) { error in
                    if let e = error {
                        // Error adding program template
                        print("\(Constants.customeErrorTextPrefix)\(e)")
                    }
                }
                programTemplate.id = ref.documentID
            }
        }
        
    }
    
    // Get Workout Templates
    func getWorkoutTemplates() {
        
        if programTemplate.id != "" {
        
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Constants.programTemplateCollection).document(programTemplate.id)
            programTemplateDoc.collection(Constants.workoutTemplateCollection).getDocuments { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot {
                        // Update the startedTemplates property in the main thread
                        DispatchQueue.main.async {
                            self.workoutTemplates = snapshot.documents.map { e in
                                // Create a ProgramTemplate for each document returned
                                let temp = WorkoutTemplate()
                                temp.id = e.documentID
                                temp.workoutName = e["workoutName"] as? String ?? ""
                                return temp
                            }
                        }
                    }
                }
                else {
                    // Handle Error
                    print("\(Constants.customeErrorTextPrefix)\(error.debugDescription)")
                }
            
            }
            
        }
        
    }
    
    // Delete Workout Template
    func deleteWorkoutTemplate(workoutTemplateToDelete: WorkoutTemplate) {
        
        if programTemplate.id != "" {
            
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Constants.programTemplateCollection).document(programTemplate.id)
            programTemplateDoc.collection(Constants.workoutTemplateCollection).document(workoutTemplateToDelete.id).delete() { error in
                // Check for errors
                if error == nil {
                    // No errors
                    // Update the UI from the main thread
                    DispatchQueue.main.async {
                        self.workoutTemplates.removeAll { workoutTemplate in
                            // Check for the Exercise to remove
                            return workoutTemplate.id == workoutTemplateToDelete.id
                        }
                    }
                }
                else {
                    // Handle Error
                    print("\(Constants.customeErrorTextPrefix)\(error.debugDescription)")
                }
            }
            
        }
        
    }
    
    // Check to see if the program template is valid. This requires at least one workout template to exist. Each workout template must have at least one exercise set template.
    func checkValid(programName: String) -> Bool {
        
        var valid = true
        
        // Refresh the workout template from the database
        self.getWorkoutTemplates()
        
        if programName == "" {
            return false
        }
        
        if self.workoutTemplates.count > 0 {
            // Loop through the templates to check if there are exercise set templates for each wokrout
            workoutTemplates.forEach { wt in
                // valid = validExerciseSetTemplates(workoutTemplateDocId: wt.id)
            }
        }
        else {
            // If there are no workout templates then this cannot be a valid program template
            valid = false
        }
        
        // print("Returning \(valid) valid status for program template \(programTemplate.programName)")
        
        // Return true for valid and false for not valid
        return valid
        
    }
    
    // Return the number of exercise set templates for a workout template
    // This is commented out because I kept having issues with getting the status to be correct. This will be added and fixed later
    /*func validExerciseSetTemplates(workoutTemplateDocId: String) -> Bool {
        
        var validExerciseSetTemplate = false
        var returnedValue = false
        
        if programTemplate.id != "", workoutTemplateDocId != "" {
        
            guard Auth.auth().currentUser != nil else {
                return false
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Constants.programTemplateCollection).document(programTemplate.id)
            let workoutTemplateDoc = programTemplateDoc.collection(Constants.workoutTemplateCollection).document(workoutTemplateDocId)
            let col = workoutTemplateDoc.collection(Constants.exerciseSetTemplateCollection)
            
            col.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    print("Query Snapshot is Empty (\(querySnapshot.do)): \(querySnapshot?.isEmpty ?? true)")
                    if querySnapshot?.isEmpty == false {
                        // We do have a snapshot if it's false
                        returnedValue = true
                    }
                }
            }
            
            // print("\(Constants.programTemplateCollection) > \(programTemplate.id) > \(Constants.workoutTemplateCollection) >  \(workoutTemplateDocId) > \(Constants.exerciseSetTemplateCollection)")
            
        }
        
        if returnedValue {
            validExerciseSetTemplate = true
        }
        
        return validExerciseSetTemplate
        
    } */
    
    
    // MARK: End
    
}
