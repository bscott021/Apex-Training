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
    
    @Published var readyTemplates = [ProgramTemplate]()
    
    // Get all the Ready Program Templates
    func getReadyProgramTemplates() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection(Constants.programTemplateCollection).whereField("status", isEqualTo: Constants.programTemplateStatus.Ready.stringValue).getDocuments { snapshot, error in

            if error == nil {
                if let snapshot = snapshot {
                    // Update the startedTemplates property in the main thread
                    DispatchQueue.main.async {
                        self.readyTemplates = snapshot.documents.map { e in
                            // Create a ProgramTemplate for each document returned
                            let temp = ProgramTemplate()
                            temp.id = e.documentID
                            temp.programName = e["programName"] as? String ?? ""
                            temp.programDescription = e["programDescription"] as? String ?? ""
                            temp.numCycles = e["numCycles"] as? String ?? ""
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
