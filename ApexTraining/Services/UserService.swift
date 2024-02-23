//
//  UserService.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/17/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class UserService {
    
    // MARK: Properties
    
    var user = User()
    
    static var shared = UserService()
    
    
    // MARK: Init
    
    /// Blank initializer
    private init() {
        getCurrentProgramInfo()
    }
    
    
    // MARK: Methods
    
    /// Set the basic info about the current program
    func getCurrentProgramInfo() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let userDoc = db.collection(Collections.usersCollection).document(Auth.auth().currentUser!.uid)
        userDoc.getDocument { snapshot, error in
            guard error == nil, snapshot != nil else {
                return
            }
            let data = snapshot?.data()
            // Set Properties for Current Program Info
            self.user.currentProgramId = data?["currentProgramId"] as? String ?? ""
            self.user.currentProgramName = data?["currentProgramName"] as? String ?? ""
            self.user.currentWorkoutId = data?["currentWorkoutId"] as? String ?? ""
            self.user.currentWorktoutName = data?["currentWorkoutName"] as? String ?? ""
        }
        
    }
    
    
    /// Set current program
    ///
    /// - Parameters:
    ///     - programDocId: Program document id for the current program
    ///     - programName: Name for the current program
    func setCurrentProgram(programDocId: String, programName: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programDocId != "", programName != "" {
            let db = Firestore.firestore()
            let userDoc = db.collection(Collections.usersCollection).document(Auth.auth().currentUser!.uid)
            userDoc.setData([
                "currentProgramId" : programDocId,
                "currentProgramName" : programName
            ], merge: true)
        }
        
    }
    
    
    /// Set current workout
    ///
    /// - Parameters:
    ///     - workoutDocId: Workout document id for the current workout
    ///     - workoutName: Name for the current workout
    func setCurrentWorkout(workoutDocId: String, workoutName: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if workoutDocId != "", workoutName != "" {
            let db = Firestore.firestore()
            let userDoc = db.collection(Collections.usersCollection).document(Auth.auth().currentUser!.uid)
            userDoc.setData([
                "currentWorkoutId" : workoutDocId,
                "currentWorkoutName" : workoutName
            ], merge: true)
        }
        
    }
    
    
    /// Begin Program: This passes in a Program but its really a template id at this point and not an actual program id yet. The program id gets created in the function when the new document is created.
    ///
    /// - Parameter programToBegin: Begin a program for the user
    func beginProgram(programToBegin: Program) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Create a Program. This ref.documentId is now the Program Id that you want to use for the program that is being created
        let ref = db.collection(Collections.programsCollection).addDocument(data: [
            "programName": programToBegin.programName,
            "programDescription": programToBegin.programDescription,
            "status": "In Progress",
            "numCycles": programToBegin.numCycles
        ]) { error in
            if let e = error {
                // Error adding Program
                print("\(Constants.customeErrorTextPrefix)\(e)")
            }
        }
        
        // Add the Workouts to the Program
        let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programToBegin.id)
        programTemplateDoc.collection(Collections.workoutTemplateCollection).getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    // Update the startedTemplates property in the main thread
                    snapshot.documents.map { e in
                        // Create a ProgramTemplate for each document returned
                        let workoutTemplateTemp = WorkoutTemplate()
                        workoutTemplateTemp.id = e.documentID
                        workoutTemplateTemp.workoutName = e["workoutName"] as? String ?? ""
                        ProgramService.shared.addWorkoutToProgram(programTemplateId: programToBegin.id, programId: ref.documentID, workoutToAdd: workoutTemplateTemp)
                    }
                }
            }
            else {
                // Handle Error
                print("\(Constants.customeErrorTextPrefix)\(error.debugDescription)")
            }
        
        }
        
        // Set the current program for the user to the new program
        self.setCurrentProgram(programDocId: ref.documentID, programName: programToBegin.programName)

    }
    
    
    /// Complete Workout
    ///
    /// - Parameters:
    ///     - workoutDocId: Workout document id to complete
    ///     - workoutName: Name of the completed workout
    func completeWorkout(workoutDocId: String, workoutName: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if workoutDocId != "", workoutName != "" {
            
            let db = Firestore.firestore()
            
            // Update Workout Status
            db.collection(Collections.workoutCollection).document(workoutDocId).setData([
                "status" : Constants.completedStatus,
                "dateTimeCompleted" : Date.now
            ], merge: true)
            
            // Update the Program Workout complete count
            var programWorkoutDocId = ""
            var programWorkoutCompleteCount = 0
            let programWorkoutCol = db.collection(Collections.programsCollection).document(user.currentProgramId).collection(Collections.programWorkoutsCollection)
            programWorkoutCol.whereField("workoutName", isEqualTo: workoutName).getDocuments { ( snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        // Get values from returned document. Should only be one based on logic but loop is required by code
                        let data = document.data()
                        programWorkoutDocId = document.documentID
                        programWorkoutCompleteCount = data["timesCompleted"] as? Int ?? 0
                    }
                    
                    // Check to see if it was looked up
                    if programWorkoutDocId != "" {
                        // Add 1 to the current completed value
                        programWorkoutCompleteCount += 1
                        // Set in the database
                        programWorkoutCol.document(programWorkoutDocId).setData([
                            "timesCompleted" : programWorkoutCompleteCount
                        ], merge: true)
                    }
                }
            }

            var lowestCount = 0
            programWorkoutCol.getDocuments() { snapshot2, error2 in
                if error2 == nil {
                    if let snapshot2 = snapshot2 {
                        // Track the highest completion count
                        snapshot2.documents.map { f in
                            let returnedCount = f["timesCompleted"] as? Int ?? 0
                            let returnedWorkoutName = f["workoutName"] as? String ?? ""
                            if (lowestCount > returnedCount) || ((lowestCount == 0) && (returnedCount > 0)) {
                                if returnedWorkoutName == workoutName {
                                    lowestCount = returnedCount + 1
                                } else {
                                    lowestCount = returnedCount
                                }
                            }
                        }
                        
                        // In case the value is not updated yet in the data base yet and this is 0, make it 1 to count this run
                        if lowestCount == 0 {
                            lowestCount = 1
                        }
                            
                        // Update the program to have the new value for completed cycles
                        db.collection(Collections.programsCollection).document(self.user.currentProgramId).setData([
                            "cyclesCompleted" : lowestCount
                        ], merge: true)
                    }
                }
                else {
                    // Handle Error
                    print("\(Constants.customeErrorTextPrefix)\(error2.debugDescription)")
                }
            }
            
            // Clear Current Workout for User
            db.collection(Collections.usersCollection).document(Auth.auth().currentUser!.uid).setData([
                "currentWorkoutId" : "",
                "currentWorkoutName" : ""
            ], merge: true)
            
        }
        
    }
    
    
    /// Complete the Program
    func completeProgram() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Set Program Status to Complete
        db.collection(Collections.programsCollection).document(user.currentProgramId).setData([
            "status" : "Complete"
        ], merge: true)
        
        // Reset the Current Program for the User
        db.collection(Collections.usersCollection).document(Auth.auth().currentUser!.uid).setData([
            "currentProgramId" : "",
            "currentProgramName" : ""
        ], merge: true)
        
    }
    
    
    // MARK: End
    
}
