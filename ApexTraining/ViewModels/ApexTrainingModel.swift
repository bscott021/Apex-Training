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
    @Published var signInError = ""
    
    // MARK: Methods
    
    /// Create a User
    ///
    /// - Parameters:
    ///     - name: Users name
    ///     - email: email address entered
    ///     - password: Password entered
    func createUser(name: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.signInError = error!.localizedDescription
                return
            }
            self.signInError = ""
            
            // Save User
            let firebaseUser = Auth.auth().currentUser
            let db = Firestore.firestore()
            let ref = db.collection(Collections.usersCollection).document(firebaseUser!.uid)
            
            ref.setData(["name":name], merge: true)
            
            let user = UserService.shared.user
            user.name = name
            
            self.checkSignIn()
            
        }
        
    }
    
    
    /// Sign In User
    ///
    /// - Parameters:
    ///     - email: String value of email address entered
    ///     - password: Password entered
    func signInUser(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.signInError = error!.localizedDescription
                return
            }
            self.signInError = ""
            self.getUserData()
            self.checkSignIn()
        }
        
    }
    
    
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
