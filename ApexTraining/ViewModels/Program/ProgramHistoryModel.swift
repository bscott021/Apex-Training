//
//  ProgramHistoryModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 9/13/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProgramHistoryModel: ObservableObject {
    
    @Published var completedPrograms:[Program]
    
    init() {
        completedPrograms = [Program]()
    }
    
    // Get Completed Workouts
    func getCompletedPrograms() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        self.completedPrograms = [Program]()
        
        let db = Firestore.firestore()
        
        // Look up workouts with status of complete
        db.collection(Constants.programsCollection).whereField("status", isEqualTo: "Complete").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    self.completedPrograms = snapshot.documents.map { e in
                        // Set the Workout level data
                        let tempProgram = Program()
                        tempProgram.id = e.documentID
                        tempProgram.programName = e["programName"] as? String ?? ""
                        tempProgram.programDescription = e["programDescription"] as? String ?? ""
                        tempProgram.status = e["status"] as? String ?? ""
                        tempProgram.numCycles = e["numCycles"] as? String ?? ""
                        tempProgram.cyclesCompleted = e["cyclesCompleted"] as? Int ?? 0
                        
                        db.collection(Constants.workoutCollection).whereField("programId", isEqualTo: tempProgram.id).getDocuments { snapshot2, error2 in
                            
                            if error2 == nil {
                                if let snapshot2 = snapshot2 {
                                    tempProgram.workouts = snapshot2.documents.map { f in
                                        let tempWorkout = Workout()
                                        tempWorkout.id = f.documentID
                                        tempWorkout.workoutName = f["workoutName"] as? String ?? ""
                                        let returnedTimestamp = f["dateTimeCompleted"] as? Timestamp ?? Timestamp()
                                        tempWorkout.dateTimeCompleted = returnedTimestamp.dateValue()
                                        tempWorkout.status = f["status"] as? String ?? ""
                                        
                                        return tempWorkout
                                    }
                                }
                            }
                            
                        }
                        
                        return tempProgram
                    }
                }
            }
            else {
                // Handle Error
                print("\(Constants.customeErrorTextPrefix)\(error.debugDescription)")
            }
        }
        
        return
        
    }
    
    
}
