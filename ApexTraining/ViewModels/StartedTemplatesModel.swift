//
//  StartedTemplatesModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/23/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class StartedTemplatesModel: ObservableObject {
    
    @Published var startedTemplates = [ProgramTempalte]()
    
    // Get all the started Program Templates
    func getProgramTemplates() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection(Constants.programTemplateCollection).getDocuments { snapshot, error in

            if error == nil {
                if let snapshot = snapshot {
                    // Update the startedTemplates property in the main thread
                    DispatchQueue.main.async {
                        self.startedTemplates = snapshot.documents.map { e in
                            // Create a ProgramTemplate for each document returned
                            let temp = ProgramTempalte()
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
