//
//  ApexTrainingModel.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ApexTrainingModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var signedIn = false

    
    // MARK: Methods
    
    /// Get user data if there is a signed in user
    func checkSignIn() {
        
        signedIn = Auth.auth().currentUser != nil ? true : false
        
        if UserService.shared.user.name != "" {
            getUserData()
        }
        
    }
    
    
    /// Get the current users data from database
    func getUserData() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let ref = db.collection(Collections.usersCollection).document(Auth.auth().currentUser!.uid)
        ref.getDocument { snapshot, error in
            guard error == nil, snapshot != nil else {
                return
            }
            let data = snapshot?.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
        }
        
    }
    
    
    // MARK: End
    
}
