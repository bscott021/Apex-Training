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
    @Published var exerciseSetTemplates = [ExerciseSetTemplate]()
    
    // MARK: Init
    
    ///  Create from just a program template id
    ///
    ///  - Parameter programTemplateDocId: Program template document id
    init(programTemplateDocId: String) {
        self.programTemplateDocId = programTemplateDocId
    }
    
    
    /// Passed in from parent
    ///
    /// - Parameters:
    ///     - programTemplateDocId: Program template document id
    ///     - workoutTemplate: Workout template object when there's already an object for it
    init(programTemplateDocId: String, workoutTemplate: WorkoutTemplate) {
        self.programTemplateDocId = programTemplateDocId
        self.workoutTemplate = workoutTemplate
    }
    
    
    // MARK: Methods
    
    ///  Get a single Program Template
    ///
    ///  - Parameters:
    ///     - programTemplateDocId:Program template document id
    ///     - workoutTemplateDocId:
    func getWorkoutTemplate(programTemplateDocId: String, workoutTemplateDocId: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get Program Template Document
        let db = Firestore.firestore()
        let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplateDocId)
        let workoutTemplateDoc = programTemplateDoc.collection(Collections.workoutTemplateCollection).document(workoutTemplateDocId)
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
    
    
    /// Save a Wokrout Template to the View Model and the database
    ///
    /// - Parameters:
    ///     - saveDB: Boolean value of if the save should be for the local copy only or write to the database as well
    ///     - name: Name of workout to be saved
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
                    // Update Existing Workout Template
                    let workoutTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplateDocId).collection(Collections.workoutTemplateCollection).document(workoutTemplate.id)
                    workoutTemplateDoc.setData(["workoutName": name], merge: true)
                }
                else {
                    // Add New Workout Template
                    let ref = db.collection(Collections.programTemplateCollection).document(programTemplateDocId).collection(Collections.workoutTemplateCollection).addDocument(data: ["workoutName": name]) { error in
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
    
    
    /// Get all the Exercise Set Templates for the Workout Template
    func getExerciseSetTemplates() {
        
        if programTemplateDocId != "", workoutTemplate.id != "" {
        
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplateDocId)
            let workoutTemplateDoc = programTemplateDoc.collection(Collections.workoutTemplateCollection).document(workoutTemplate.id)
            workoutTemplateDoc.collection(Collections.exerciseSetTemplateCollection).getDocuments { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot {
                        // Update the startedTemplates property in the main thread
                        DispatchQueue.main.async {
                            self.exerciseSetTemplates = snapshot.documents.map { e in
                                // Create a ProgramTemplate for each document returned
                                let temp = ExerciseSetTemplate()
                                temp.id = e.documentID
                                temp.exerciseName = e["exerciseName"] as? String ?? ""
                                temp.numReps = e["numReps"] as? Int ?? 0
                                temp.numSets = e["numSets"] as? Int ?? 0
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
    
    
    /// Add New Exercise Set Template
    ///
    /// - Parameters:
    ///     - saveDB: Boolean to determine if the save should also write to the db
    ///     - name: Name of the exercise and it's sets
    ///     - numSets: Number of sets for the exercise
    ///     - numReps: Number of reps for the sets
    func addExerciseSetTemplate(saveDB: Bool, name: String, numSets: Int, numReps: Int) {
        
        if programTemplateDocId != "", workoutTemplate.id != "" {
        
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            if saveDB {
                
                let db = Firestore.firestore()
                let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplateDocId)
                let workoutTemplateDoc = programTemplateDoc.collection(Collections.workoutTemplateCollection).document(workoutTemplate.id)
                
                // Create New Exercise Set Template
                workoutTemplateDoc.collection("exerciseSetTemplates").addDocument(data: [
                    "exerciseName": name,
                    "numSets": numSets,
                    "numReps": numReps
                ]) { error in
                    if let e = error {
                        // Error adding program template
                        print("\(Constants.customeErrorTextPrefix)\(e)")
                    }
                }
                
            }
            
        }

    }
    
    
    ///  Update Existing Exercise Set Template
    ///
    ///  - Parameters:
    ///     - exerciseSetTemplateId: Exercise set template document id
    ///     - name : Exercise set template name
    ///     - numSets: Numnber of sets for the exercise set
    ///     - numReps: Number of reps for the exercise set
    func updateExerciseSetTemplate(exerciseSetTemplateId: String, name: String, numSets: Int, numReps: Int) {
        
        if programTemplateDocId != "", workoutTemplate.id != "" {
        
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplateDocId)
            let workoutTemplateDoc = programTemplateDoc.collection(Collections.workoutTemplateCollection).document(workoutTemplate.id)
            let exerciseSetTemplateDoc = workoutTemplateDoc.collection("exerciseSetTemplates").document(exerciseSetTemplateId)
            exerciseSetTemplateDoc.setData([
                "exerciseName": name,
                "numSets": numSets,
                "numReps": numReps
            ], merge: true)
            
        }
        
    }
    
    
    /// Delete Exercise Sert Template
    ///
    /// - Parameter exerciseSetTemplateToDelete: Exercise set template object that is to be deleted
    func deleteExerciseSetTemplate(exerciseSetTemplateToDelete: ExerciseSetTemplate) {
        
        if programTemplateDocId != "", workoutTemplate.id != "" {
            
            guard Auth.auth().currentUser != nil else {
                return
            }
            
            let db = Firestore.firestore()
            let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplateDocId)
            let workoutTemplateDoc = programTemplateDoc.collection(Collections.workoutTemplateCollection).document(workoutTemplate.id)
            workoutTemplateDoc.collection("exerciseSetTemplates").document(exerciseSetTemplateToDelete.id).delete() { error in
                // Check for errors
                if error == nil {
                    // No errors
                    // Update the UI from the main thread
                    DispatchQueue.main.async {
                        self.exerciseSetTemplates.removeAll { exerciseSetTemplate in
                            // Check for the Exercise to remove
                            return exerciseSetTemplate.id == exerciseSetTemplateToDelete.id
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
    
    
    // MARK: End
    
}
