//
//  ProgramTemplateModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/18/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProgramTemplateModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var programTemplate = ProgramTempalte()
    
    // MARK: Init
    
    // Create New Program Template
    init() {
        // Don't fetch anything
    }
    
    // Load program template by document id
    init(docId: String) {
        // Get an existing document
        getProgramTemplate(docId: docId)
    }
    
    // MARK: Methods
    
    // Get a single Program Template
    func getProgramTemplate(docId: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let doc = db.collection(Constants.programTemplateCollection).document(docId)
        doc.getDocument { snapshot, error in
            guard error == nil, snapshot != nil else {
                return
            }
            let data = snapshot?.data()
            // Set Program Template Properties
            self.programTemplate.id = doc.documentID
            self.programTemplate.programName = data?["programName"] as? String ?? ""
            self.programTemplate.programDescription = data?["programDescription"] as? String ?? ""
            self.programTemplate.numCycles = data?["numCycles"] as? String ?? ""
        }
        
    }
    
    
    // Save a program template to the view model and the database if the scenario requires it. If there is already a document, update it. Otherwise create a new document.
    func saveProgramTemplate(saveDB: Bool, name: String, description: String, numWeeks: String) {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Assign properites to the model. This could also be done by reusing the get method but I don't know if it's necessary to fetch from the db again
        programTemplate.programName = name
        programTemplate.programDescription = description
        programTemplate.numCycles = numWeeks
        
        if saveDB {
            let db = Firestore.firestore()
            // Update an existing Program Template by document id
            if programTemplate.id != "" {
                let doc = db.collection(Constants.programTemplateCollection).document(programTemplate.id)
                doc.setData([
                    "programName": name,
                    "programDescription": description,
                    "numCycles": numWeeks
                ], merge: true)
            }
            // Create a new Program Template in the db
            else {
                let ref = db.collection(Constants.programTemplateCollection).addDocument(data: [
                    "programName": name,
                    "programDescription": description,
                    "numCycles": numWeeks
                ]) { error in
                    if let e = error {
                        // Error adding program template
                        print("\(Constants.customeErrorTextPrefix)\(e)")
                    }
                }
                programTemplate.id = ref.documentID
            }
        }
        
    }
    
    
}
