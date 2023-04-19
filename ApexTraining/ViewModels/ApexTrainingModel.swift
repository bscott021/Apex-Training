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
    
    @Published var signedIn = false
    
    func checkSignIn() {
        
        signedIn = Auth.auth().currentUser != nil ? true : false
        
        if UserService.shared.user.name != "" {
            getUserData()
        }
        
    }
    
    func getUserData() {
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        ref.getDocument { snapshot, error in
            guard error == nil, snapshot != nil else {
                return
            }
            let data = snapshot?.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
        }
        
    }
    
}
