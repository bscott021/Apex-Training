//
//  ProgramService.swift
//  ApexTraining
//
//  Created by Brendan Scott on 11/8/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


class ProgramService {
    
    // MARK: Properties
    
    static var shared = ProgramService()
    
    
    // MARK: Init
    
    /// Blank initializer
    private init() {
    }
    
    
    // MARK: Methods
    
    /// Add Program Workouts
    ///
    /// - Parameters:
    ///     - programTemplateId: Program template id of the program the workout template is in
    ///     - programId: Program id to add the workout to
    ///     - workoutToAdd: Workout template object to add
    func addWorkoutToProgram(programTemplateId: String, programId: String, workoutToAdd: WorkoutTemplate) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programId != "" {
        
            // Add a Workout to the Program
            let db = Firestore.firestore()
            let ref = db.collection(Collections.programsCollection).document(programId).collection(Collections.programWorkoutsCollection).addDocument(data: [
                "workoutName": workoutToAdd.workoutName
            ]) { error in
                if let e = error {
                    // Error adding Program
                    print("\(Constants.customeErrorTextPrefix)\(e)")
                }
            }
            
            // Get the ExerciseSetTemplates and
            let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(programTemplateId)
            let workoutTemplateDoc = programTemplateDoc.collection(Collections.workoutTemplateCollection).document(workoutToAdd.id)
            workoutTemplateDoc.collection(Collections.exerciseSetTemplateCollection).getDocuments { snapshot, error in
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
    
    
    /// Add Exercise to a Workout in a Program
    ///
    /// - Parameters:
    ///     - programId: Program id the workout is in
    ///     - workoutId: Workout id the exercise set should be added to
    ///     - exerciseToAdd: Exercise set template to add to the workout
    func addExerciseToProgramWorkout(programId: String, workoutId: String, exerciseToAdd: ExerciseSetTemplate) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programId != "", workoutId != "" {
        
            let db = Firestore.firestore()
            db.collection(Collections.programsCollection).document(programId).collection(Collections.programWorkoutsCollection).document(workoutId).collection(Collections.exercisesCollection).addDocument(data: [
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
    
    
    /// Create Workout
    ///
    /// - Parameters:
    ///     - programId: Program id the workout is for
    ///     - workout: Workout object to create
    /// - Returns Workout object
    func createWorkout(programId: String, workout: Workout) -> Workout {
        
        guard Auth.auth().currentUser != nil else {
            return Workout()
        }
        
        if programId != "", workout.id != "" {
            
            let db = Firestore.firestore()
            
            /* Create the workout in the workout collection */
            let workoutRef = db.collection(Collections.workoutCollection).addDocument(data: [
                "programId" : programId,
                "workoutName" : workout.workoutName,
                "status" : Constants.newStatus
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
            
            // Set the status to new
            workout.status = Constants.newStatus
            
            /* Loop through the exercises and create them in the database. At this point the exercise sets should be created for this since the workout has been started. */
            for e in workout.exercises {
                let exercisesRef = db.collection(Collections.exercisesCollection).addDocument(data: [
                    "exerciseName" : e.exerciseName,
                    "numSets" : e.numSets,
                    "status" : Constants.notStartedStatus
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
                
                // Set the status for the exercise
                e.status = Constants.notStartedStatus
                
                // Save the Exercise Id to the Workout
                workoutRef.collection(Collections.exercisesCollection).addDocument(data: [
                    "exerciseId" : exercisesRef.documentID
                ])
                
            }
            
            return workout

        }
        
        return Workout()
        
    }
    
    
    ///  Get workout from the workout collection
    ///
    ///  - Parameter workoutDodIdToGet: Workout document id to get from the database
    ///  - Returns Workout object from database
    func getWorkout(workoutDocIdToGet: String) -> Workout {
        
        guard Auth.auth().currentUser != nil else {
            return Workout()
        }
        
        let tempWorkout = Workout()
        let db = Firestore.firestore()
        
        if workoutDocIdToGet != "" {
            
            // Get the Workout data fromt he workouts collection
            let workoutDoc = db.collection(Collections.workoutCollection).document(workoutDocIdToGet)
            // Get and set workout level data
            workoutDoc.getDocument() { snapshot, error in
                guard error == nil, snapshot != nil else {
                    return
                }
                let data = snapshot?.data()
                // Set Workout Properties
                tempWorkout.id = workoutDocIdToGet
                tempWorkout.workoutName = data?["workoutName"] as? String ?? ""
                let returnedTimestamp = data?["dateTimeCompleted"] as? Timestamp ?? Timestamp()
                tempWorkout.dateTimeCompleted = returnedTimestamp.dateValue()
                tempWorkout.status = data?["status"] as? String ?? ""
            }
            
            // Get the ExerciseSet data from the exercises collection
            workoutDoc.collection(Collections.exercisesCollection).getDocuments() { snapshot2, error2 in
                if error2 == nil {
                    if let snapshot2 = snapshot2 {
                        for doc in snapshot2.documents {
                            let docData = doc.data()
                            if let exerciseId = docData["exerciseId"] as? String {
                                let tempExerciseSet = ExerciseSet()
                                tempExerciseSet.id = exerciseId
                                // Get and assign Exercise level data
                                db.collection(Collections.exercisesCollection).document(exerciseId).getDocument() { snapshot3, error3 in
                                    guard error3 == nil, snapshot3 != nil else {
                                        return
                                    }
                                    let exerciseData = snapshot3?.data()
                                    // Set ExerciseSet Properties
                                    tempExerciseSet.exerciseName = exerciseData?["exerciseName"] as? String ?? ""
                                    tempExerciseSet.numSets = exerciseData?["numSets"] as? Int ?? 0
                                    tempExerciseSet.status = exerciseData?["status"] as? String ?? ""
                                }
                                // Get and assign Set level data
                                db.collection(Collections.exercisesCollection).document(exerciseId).collection(Collections.setsCollection).getDocuments() { snapshot4, error4 in
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
    
    
    ///     Update the workout status in Firebase
    ///
    ///     - Parameters
    ///         - workoutDocId: String value for the workout doucment id
    ///         - newStatusString: Status that the workout should be set to 
    func updateWorkoutStatus(workoutDocId: String, newStatusString: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if workoutDocId != "" && newStatusString != "" {
            
            var statusValue = ""
            
            if newStatusString == Constants.newStatus {
                statusValue = Constants.newStatus
            }
            if newStatusString == Constants.inProgressStatus {
                statusValue = Constants.inProgressStatus
            }
            if newStatusString == Constants.completedStatus {
                statusValue = Constants.completedStatus
            }
            
            let db = Firestore.firestore()
            
            /* Create the workout in the workout collection */
            let workoutDoc = db.collection(Collections.workoutCollection).document(workoutDocId)
            workoutDoc.setData([
                "status" : statusValue
            ], merge: true)
            
        }
        
    }
     
    // MARK: End
    
}

