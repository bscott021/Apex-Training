//
//  ReadyTemplatesModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/8/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ReadyTemplatesModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var readyPrograms = [Program]()
    
    
    // MARK: Methods
    
    /// Get all the Ready Programs
    func getReadyPrograms() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection(Collections.programTemplateCollection).whereField("status", isEqualTo: ProgramTemplateStatus.Ready.stringValue).getDocuments { snapshot, error1 in
            if error1 == nil {
                if let snapshot = snapshot {
                    // Update the readyPrograms property in the main thread
                    DispatchQueue.main.async {
                        self.readyPrograms = snapshot.documents.map { e in
                            // Create a ProgramTemplate for each document returned
                            
                            // Set the Program level data
                            let programTemp = Program()
                            programTemp.id = e.documentID
                            programTemp.programName = e["programName"] as? String ?? ""
                            programTemp.programDescription = e["programDescription"] as? String ?? ""
                            programTemp.numCycles = e["numCycles"] as? String ?? ""
                            
                            // Populate the workouts
                            let programTemplateDoc = db.collection(Collections.programTemplateCollection).document(e.documentID)
                            programTemplateDoc.collection(Collections.workoutTemplateCollection).getDocuments { snapshot, error2 in
                                if error2 == nil {
                                    if let snapshot = snapshot {
                                        // Update the startedTemplates property in the main thread
                                        programTemp.workouts = snapshot.documents.map { f in
                                            // Create a Workout for each document returned
                                            
                                            // Set the Workout level data
                                            let workoutTemp = Workout()
                                            workoutTemp.id = f.documentID
                                            workoutTemp.workoutName = f["workoutName"] as? String ?? ""
                                            
                                            // Populate the Exercises
                                            let workoutTemplateDoc = programTemplateDoc.collection(Collections.workoutTemplateCollection).document(f.documentID)
                                            workoutTemplateDoc.collection(Collections.exerciseSetTemplateCollection).getDocuments { snapshot, error3 in
                                                if error3 == nil {
                                                    if let snapshot = snapshot {
                                                        // Update the startedTemplates property in the main thread
                                                        workoutTemp.exercises = snapshot.documents.map { g in
                                                            // Create a ProgramTemplate for each document returned
                                                            let exerciseTemp = ExerciseSet()
                                                            exerciseTemp.id = g.documentID
                                                            exerciseTemp.exerciseName = g["exerciseName"] as? String ?? ""
                                                            exerciseTemp.numSets = g["numSets"] as? Int ?? 0
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
                                else {
                                    // Handle Error
                                    print("\(Constants.customeErrorTextPrefix)\(error2.debugDescription)")
                                }
                            
                            }
                            return programTemp
                        }
                    }
                }
            }
            else {
                // Handle Error
                print("\(Constants.customeErrorTextPrefix)\(error1.debugDescription)")
            }
        }
    }
    
    
    // MARK: End 
    
}
