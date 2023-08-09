//
//  ProgramModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/14/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProgramModel: ObservableObject {
    
    // MARK: Properties
    
    var user = UserService.shared.user
    
    @Published var currentProgram = Program()
    
    init() {
    }
    
    init(programDocId: String) {
        getProgram(programDocIdToGet: programDocId)
    }
    
    // Get the Program and set the values into currentProgram
    func getProgram(programDocIdToGet: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        if programDocIdToGet != "" {
            
            let db = Firestore.firestore()
            
            // Set the Program Level Info
            let programDoc = db.collection(Constants.programsCollection).document(programDocIdToGet)
            programDoc.getDocument { snapshot, error in
                guard error == nil, snapshot != nil else {
                    return
                }
                let data = snapshot?.data()
                // Set Program Properties
                self.currentProgram.id = programDoc.documentID
                self.currentProgram.programName = data?["programName"] as? String ?? ""
                self.currentProgram.programDescription = data?["programDescription"] as? String ?? ""
                self.currentProgram.numCycles = data?["numCycles"] as? String ?? ""
                self.currentProgram.cyclesCompleted = data?["cyclesCompleted"] as? Int ?? 0
                
                // Get the workouts in the collection for the program
                programDoc.collection(Constants.programWorkoutsCollection).getDocuments { snapshot2, error2 in
                    if error2 == nil {
                        if let snapshot2 = snapshot2 {
                            DispatchQueue.main.async {
                                self.currentProgram.workouts = snapshot2.documents.map { e in
                                    // Create a Workout for each document returned
                                    let workoutTemp = Workout()
                                    workoutTemp.id = e.documentID
                                    workoutTemp.workoutName = e["workoutName"] as? String ?? ""
                                    workoutTemp.timesCompleted = e["timesCompleted"] as? Int ?? 0
                                    
                                    // Get the exercises for the programWorkout
                                    let workoutDoc = programDoc.collection(Constants.programWorkoutsCollection).document(e.documentID)
                                    workoutDoc.collection(Constants.exercisesCollection).getDocuments { snapshot3, error3 in
                                        if error3 == nil {
                                            if let snapshot3 = snapshot3 {
                                                workoutTemp.exercises = snapshot3.documents.map { f in
                                                    // Create an Exercise for each doc returned
                                                    let exerciseTemp = ExerciseSet()
                                                    exerciseTemp.id = f.documentID
                                                    exerciseTemp.exerciseName = f["exerciseName"] as? String ?? ""
                                                    exerciseTemp.numSets = f["numSets"] as? Int ?? 0
                                                    exerciseTemp.numReps = f["numReps"] as? Int ?? 0
                                                    return exerciseTemp
                                                }
                                            }
                                        }
                                        else {
                                            // Handle Error
                                            print("\(Constants.customeErrorTextPrefix)\(error3.debugDescription)")
                                        }
                                    }
                                    
                                    return workoutTemp
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
            
        }
        
    }
    
    
}
