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
    
    /// Create New Program Template
    init() {
        // Don't fetch anything
    }
    
    
    /// Load program template by document id
    ///
    /// - Parameter programTemplateDocId: Program template document id to load
    init(programTemplateDocId: String) {
        // Get an existing document
        if programTemplateDocId != "" {
            getProgramTemplate(docId: programTemplateDocId)
        }
    }
    
    
    // MARK: Methods
    
    /// Get a single Program Template
    ///
    /// - Parameter docid: Program template document id
    func getProgramTemplate(docId: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let doc = db.collection(Collections.programTemplateCollection).document(docId)
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
    
    
    /// Save a program template to the database
    ///
    /// - Parameters:
    ///     - saveDB: Boolean values for if there should be a save made to the databse
    ///     - name: Program name
    ///     - description:Program description
    ///     - numWeeks: Number of weeks for the program
    ///     - status: Program status
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
                let doc = db.collection(Collections.programTemplateCollection).document(programTemplate.id)
                doc.setData([
                    "programName": name,
                    "programDescription": description,
                    "numCycles": numWeeks,
                    "status": status
                ], merge: true)
            }
            // Create a new Program Template in the db
            else {
                let ref = db.collection(Collections.programTemplateCollection).addDocument(data: [
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
    
    
    /// Get Workout Templates
    func getWorkoutTemplates() {
        
        if programTemplate.id != "" {
        
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplate.id)
            programTemplateDoc.collection(Collections.workoutTemplateCollection).getDocuments { snapshot, error in
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
    
    
    /// Delete Workout Template
    ///
    /// - Parameter workoutTemplateToDelete: Workout template object that is to be deleted
    func deleteWorkoutTemplate(workoutTemplateToDelete: WorkoutTemplate) {
        
        if programTemplate.id != "" {
            
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplate.id)
            programTemplateDoc.collection(Collections.workoutTemplateCollection).document(workoutTemplateToDelete.id).delete() { error in
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
    
    
    ///  Check to see if the program template is valid
    ///
    ///  - Parameter programName: Name of program to check
    ///  - Returns _:  Boolean value of true for valid programs and false for invalid programs
    func checkValid(programName: String) -> Bool {
        
        // This requires at least one workout template to exist.
        // Each workout template must have at least one exercise set template.
        
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
    
    
    // MARK: End
    
}
