//
//  SignInView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignInView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    
    @State var signInMode = SignInMode.signIn
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage:String?
    
    var buttonText:String {
        if signInMode == SignInMode.signIn {
            return Constants.signIn
        }
        else {
            return Constants.createAccount
        }
    }
    
    var body: some View {
        
        ZStack {
            
            // Create the box around the Sign In
            Rectangle()
                .frame(height: 275)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            VStack {
                
                Text(Constants.appName)
                    .font(.title)
                
                // Email
                TextField(Constants.email, text: $email)
                    .textFieldStyle(.roundedBorder)
                    .shadow(radius: 2)
                if signInMode == SignInMode.createAccount {
                    TextField(Constants.name, text: $name)
                        .textFieldStyle(.roundedBorder)
                        .shadow(radius: 2)
                }
                // Password
                SecureField(Constants.password, text: $password)
                    .textFieldStyle(.roundedBorder)
                    .shadow(radius: 2)
                
                // Sign In / Create Account Picker
                Picker(selection: $signInMode, label: Text("Placeholder")) {
                    // Sign In Option
                    Text(Constants.signIn)
                        .tag(SignInMode.signIn)
                    // Create Account Option
                    Text(Constants.createAccount)
                        .tag(SignInMode.createAccount)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Display the error message if there is one
                if errorMessage != nil {
                    Text(errorMessage!)
                }
                
                // Sign In / Create Account Button
                Button {
                    if signInMode == SignInMode.signIn {
                        Auth.auth().signIn(withEmail: email, password: password) { result, error in
                            guard error == nil else {
                                errorMessage = error!.localizedDescription
                                return
                            }
                            self.errorMessage = nil
                            
                            self.model.getUserData()
                            
                            self.model.checkSignIn()
                        }
                    } else {
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            guard error == nil else {
                                errorMessage = error!.localizedDescription
                                return
                            }
                            self.errorMessage = nil
                            
                            // Save User
                            let firebaseUser = Auth.auth().currentUser
                            let db = Firestore.firestore()
                            let ref = db.collection("users").document(firebaseUser!.uid)
                            
                            ref.setData(["name":name], merge: true)
                            
                            let user = UserService.shared.user
                            user.name = name
                            
                            model.checkSignIn()
                            
                        }
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(height: 30)
                            .cornerRadius(10)
                        Text(buttonText)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
        
    }
    
}

/*
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
*/

