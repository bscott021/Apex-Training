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
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        getCurrentProgramInfo()
    }
    
    // Set the basic info about the current program
    func getCurrentProgramInfo() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let userDoc = db.collection(Constants.usersCollection).document(Auth.auth().currentUser!.uid)
        userDoc.getDocument { snapshot, error in
            guard error == nil, snapshot != nil else {
                return
            }
            let data = snapshot?.data()
            // Set Properties for Current Program Info
            self.user.currentProgramId = data?["currentProgramId"] as? String ?? ""
            self.user.currentProgramName = data?["currentProgramName"] as? String ?? ""
        }
        
    }
    
    // Set current program
    func setCurrentProgram(programDocId: String, programName: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programDocId != "", programName != "" {
            let db = Firestore.firestore()
            let userDoc = db.collection(Constants.usersCollection).document(Auth.auth().currentUser!.uid)
            userDoc.setData([
                "currentProgramId" : programDocId,
                "currentProgramName" : programName
            ], merge: true)
        }
        
    }
    
    // Begin Program: This passes in a Program but its really a template id at this point and not an actual program id yet. The program id gets created in the function when the new document is created.
    func beginProgram(programToBegin: Program) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        
        // Create a Program. This ref.documentId is now the Program Id that you want to use for the program that is being created
        let ref = db.collection(Constants.programsCollection).addDocument(data: [
            "programName": programToBegin.programName,
            "programDescription": programToBegin.programDescription,
            "numCycles": programToBegin.numCycles
        ]) { error in
            if let e = error {
                // Error adding Program
                print("\(Constants.customeErrorTextPrefix)\(e)")
            }
        }
        
        // Add the Workouts to the Program
        let programTemplateDoc = db.collection(Constants.programTemplateCollection).document(programToBegin.id)
        programTemplateDoc.collection(Constants.workoutTemplateCollection).getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    // Update the startedTemplates property in the main thread
                    //DispatchQueue.main.async {
                        snapshot.documents.map { e in
                            // Create a ProgramTemplate for each document returned
                            let workoutTemplateTemp = WorkoutTemplate()
                            workoutTemplateTemp.id = e.documentID
                            workoutTemplateTemp.workoutName = e["workoutName"] as? String ?? ""
                            self.addWorkoutToProgram(programTemplateId: programToBegin.id, programId: ref.documentID, workoutToAdd: workoutTemplateTemp)
                        }
                    //}
                }
            }
            else {
                // Handle Error
                print("\(Constants.customeErrorTextPrefix)\(error.debugDescription)")
            }
        
        }
        
        // Set the current program for the user to the new program
        setCurrentProgram(programDocId: ref.documentID, programName: programToBegin.programName)
        
    }
    
    // Add Program Workouts
    func addWorkoutToProgram(programTemplateId: String, programId: String, workoutToAdd: WorkoutTemplate) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programId != "" {
        
            // Add a Workout to the Program
            let db = Firestore.firestore()
            let ref = db.collection(Constants.programsCollection).document(programId).collection(Constants.programWorkoutsCollection).addDocument(data: [
                "workoutName": workoutToAdd.workoutName
            ]) { error in
                if let e = error {
                    // Error adding Program
                    print("\(Constants.customeErrorTextPrefix)\(e)")
                }
            }
            
            // Get the ExerciseSetTemplates and
            let programTemplateDoc = db.collection(Constants.programTemplateCollection).document(programTemplateId)
            let workoutTemplateDoc = programTemplateDoc.collection(Constants.workoutTemplateCollection).document(workoutToAdd.id)
            workoutTemplateDoc.collection(Constants.exerciseSetTemplateCollection).getDocuments { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot {
                        // Update the startedTemplates property in the main thread
                        //DispatchQueue.main.async {
                            snapshot.documents.map { e in
                                // Create a ProgramTemplate for each document returned
                                let exerciseSetTemp = ExerciseSetTemplate()
                                exerciseSetTemp.id = e.documentID
                                exerciseSetTemp.exerciseName = e["exerciseName"] as? String ?? ""
                                exerciseSetTemp.numSets = e["numSets"] as? Int ?? 0
                                //self.addExercset
                                self.addExerciseToProgramWorkout(programId: programId, workoutId: ref.documentID, exerciseToAdd: exerciseSetTemp)
                            }
                        //}
                    }
                }
                else {
                    // Handle Error
                    print("\(Constants.customeErrorTextPrefix)\(error.debugDescription)")
                }
            
            }
            
        }
        
    }
    
    // Add Exercise to a Workout in a Program
    func addExerciseToProgramWorkout(programId: String, workoutId: String, exerciseToAdd: ExerciseSetTemplate) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programId != "", workoutId != "" {
        
            let db = Firestore.firestore()
            db.collection(Constants.programsCollection).document(programId).collection(Constants.programWorkoutsCollection).document(workoutId).collection(Constants.exercisesCollection).addDocument(data: [
                "exerciseName": exerciseToAdd.exerciseName,
                "numSets": exerciseToAdd.numSets
            ]) { error in
                if let e = error {
                    // Error adding Program
                    print("\(Constants.customeErrorTextPrefix)\(e)")
                }
            }
            
        }
        
    }
    
}
