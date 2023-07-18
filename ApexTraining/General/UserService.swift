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
            self.user.currentWorkoutId = data?["currentWorkoutId"] as? String ?? ""
            self.user.currentWorktoutName = data?["currentWorkoutName"] as? String ?? ""
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
    
    // Set current workout
    func setCurrentWorkout(workoutDocId: String, workoutName: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if workoutDocId != "", workoutName != "" {
            let db = Firestore.firestore()
            let userDoc = db.collection(Constants.usersCollection).document(Auth.auth().currentUser!.uid)
            userDoc.setData([
                "currentWorkoutId" : workoutDocId,
                "currentWorkoutName" : workoutName
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
                    snapshot.documents.map { e in
                        // Create a ProgramTemplate for each document returned
                        let workoutTemplateTemp = WorkoutTemplate()
                        workoutTemplateTemp.id = e.documentID
                        workoutTemplateTemp.workoutName = e["workoutName"] as? String ?? ""
                        self.addWorkoutToProgram(programTemplateId: programToBegin.id, programId: ref.documentID, workoutToAdd: workoutTemplateTemp)
                    }
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
                        snapshot.documents.map { e in
                            // Create a ProgramTemplate for each document returned
                            let exerciseSetTemp = ExerciseSetTemplate()
                            exerciseSetTemp.id = e.documentID
                            exerciseSetTemp.exerciseName = e["exerciseName"] as? String ?? ""
                            exerciseSetTemp.numSets = e["numSets"] as? Int ?? 0
                            exerciseSetTemp.numReps = e["numReps"] as? Int ?? 0
                            self.addExerciseToProgramWorkout(programId: programId, workoutId: ref.documentID, exerciseToAdd: exerciseSetTemp)
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
    
    // Add Exercise to a Workout in a Program
    func addExerciseToProgramWorkout(programId: String, workoutId: String, exerciseToAdd: ExerciseSetTemplate) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programId != "", workoutId != "" {
        
            let db = Firestore.firestore()
            db.collection(Constants.programsCollection).document(programId).collection(Constants.programWorkoutsCollection).document(workoutId).collection(Constants.exercisesCollection).addDocument(data: [
                "exerciseName": exerciseToAdd.exerciseName,
                "numSets": exerciseToAdd.numSets,
                "numReps": exerciseToAdd.numReps
            ]) { error in
                if let e = error {
                    // Error adding Program
                    print("\(Constants.customeErrorTextPrefix)\(e)")
                }
            }
            
        }
        
    }
    
    
    func createWorkout(workout: Workout) -> Workout {
        
        let db = Firestore.firestore()
        
        /* Create the workout in the workout collection */
        let workoutRef = db.collection(Constants.workoutCollection).addDocument(data: [
                "workoutName" : workout.workoutName
            ]) { error in
            if let e = error {
                // Error adding workout
                print("\(Constants.customeErrorTextPrefix)\(e)")
            }
        }
        
        // Set the id so it's picked correct to the created workout when the object is returned back for the view to pass around
        if workoutRef.documentID != "" {
            workout.id = workoutRef.documentID
        }
        
        /* Loop through the exercises and create them in the database. At this point the exercise sets should be created for this since the workout has been started. */
        for e in workout.exercises {
            let exercisesRef = db.collection(Constants.exercisesCollection).addDocument(data: [
                "exerciseName":e.exerciseName,
                "numSets":e.numSets
            ]) { error in
                if let e = error {
                    // Error adding Exercise
                    print("\(Constants.customeErrorTextPrefix)\(e)")
                }
            }
            
            // Set the id so it's returned correct when the workout is passed back
            if exercisesRef.documentID != "" {
                e.id = exercisesRef.documentID
            }
            
            // Create new sets for the Exercise
            for i in 1 ..< (e.numSets + 1) {
                // Create in db
                let returnDoc = exercisesRef.collection(Constants.setsCollection).addDocument(data: [
                    "setNum" : i,
                    "numReps" : e.numReps,
                    "weight" : 0
                ])
                
                // Create in workout object
                let tempSet = Set()
                tempSet.id = returnDoc.documentID
                tempSet.setNum = i
                tempSet.numReps = e.numReps
                tempSet.weight = 0
                workout.exercises.first(where: { $0.id == e.id })?.sets.append(tempSet)
            }
            
            // Save the Exercise Id to the Workout
            workoutRef.collection(Constants.exercisesCollection).addDocument(data: [
                "exerciseId" : exercisesRef.documentID
            ])
            
        }
        
        return workout
        
    }
    
    // Get workout from the workout collection
    func getWorkout(workoutDocIdToGet: String) -> Workout {
        
        guard Auth.auth().currentUser != nil else {
            return Workout()
        }
        
        let tempWorkout = Workout()
        let db = Firestore.firestore()
        
        if workoutDocIdToGet != "" {
            
            // Get the Workout data fromt he workouts collection
            let workoutDoc = db.collection(Constants.workoutCollection).document(workoutDocIdToGet)
            // Get and set workout level data
            workoutDoc.getDocument() { snapshot, error in
                guard error == nil, snapshot != nil else {
                    return
                }
                let data = snapshot?.data()
                // Set Workout Properties
                tempWorkout.id = workoutDocIdToGet
                tempWorkout.workoutName = data?["workoutName"] as? String ?? ""
            }
            
            // Get the ExerciseSet data from the exercises collection
            workoutDoc.collection(Constants.exercisesCollection).getDocuments() { snapshot2, error2 in
                if error2 == nil {
                    if let snapshot2 = snapshot2 {
                        for doc in snapshot2.documents {
                            let docData = doc.data()
                            if let exerciseId = docData["exerciseId"] as? String {
                                let tempExerciseSet = ExerciseSet()
                                tempExerciseSet.id = exerciseId
                                // Get and assign Exercise level data
                                db.collection(Constants.exercisesCollection).document(exerciseId).getDocument() { snapshot3, error3 in
                                    guard error3 == nil, snapshot3 != nil else {
                                        return
                                    }
                                    let exerciseData = snapshot3?.data()
                                    // Set ExerciseSet Properties
                                    tempExerciseSet.exerciseName = exerciseData?["exerciseName"] as? String ?? ""
                                    tempExerciseSet.numSets = exerciseData?["numSets"] as? Int ?? 0
                                }
                                // Get and assign Set level data
                                db.collection(Constants.exercisesCollection).document(exerciseId).collection(Constants.setsCollection).getDocuments() { snapshot4, error4 in
                                    if error4 == nil {
                                        if let snapshot4 = snapshot4 {
                                            for setDoc in snapshot4.documents {
                                                let tempSet = Set()
                                                let setDocData = setDoc.data()
                                                // Assign Set data
                                                tempSet.id = setDoc.documentID
                                                tempSet.setNum = setDocData["setNum"] as? Int ?? 0
                                                tempSet.numReps = setDocData["numReps"] as? Int ?? 0
                                                tempSet.weight = setDocData["weight"] as? Int ?? 0
                                                
                                                tempExerciseSet.sets.append(tempSet)
                                            }
                                        }
                                    }
                                }
                                tempWorkout.exercises.append(tempExerciseSet)
                            }
                        }
                    }
                }
                else {
                    // Handle Error
                    print("\(Constants.customeErrorTextPrefix)\(error2.debugDescription)")
                }
            }
            
        }
        
        return tempWorkout
        
    }
    
    
    
}
