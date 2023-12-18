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
        
        GeometryReader { geo in
        
            ZStack {
                
                // Background
                Rectangle()
                    .foregroundColor(Color(ApexColors.primary))
                    .ignoresSafeArea()
                
                VStack (spacing: 10) {
                    
                    // App Name
                    Text(Constants.appName)
                        .foregroundColor(Color(ApexColors.nearWhite))
                        .font(.title)
                    
                    // MARK: Text Fields
                    
                    // Name
                    if signInMode == SignInMode.createAccount {
                        ApexTextField(field: $name, labelText: Constants.name, image: Symbols.profileImage)
                    }
                    
                    // Email
                    ApexTextField(field: $email, labelText: Constants.email, image: Symbols.emailImage)
                    
                    // Password
                    ApexSecureTextField(field: $password, labelText: Constants.password, image: Symbols.passwordImage)
                    
                    // Display the error message if there is one
                    if errorMessage != nil {
                        Text(errorMessage!)
                            .foregroundColor(Color(ApexColors.nearWhite))
                    }
                    
                    // MARK: Buttons
                    
                    // Change Button based on Sin In mode
                    switch(signInMode) {
                    case SignInMode.signIn:
                        
                        // Sign in
                        Button {
                            self.model.signInUser(email: email, password: password)
                            errorMessage = self.model.signInError
                        } label: {
                                ButtonBackground(buttonText: Constants.signIn)
                        }
                        
                        // Sign in With Google Button
                        Button {
                            // TODO: Future Task
                        } label: {
                            ButtonBackground(buttonText: Constants.signInWithGoogle)
                        }
                        
                        // Create Account Screen
                        Button {
                            signInMode = SignInMode.createAccount
                        } label: {
                            ButtonBackground(buttonText: Constants.createAccount)
                        }
                        
                    case SignInMode.createAccount:
                        
                        // Create Account
                        Button {
                            self.model.createUser(name: name, email: email, password: password)
                            errorMessage = self.model.signInError
                        } label: {
                            ButtonBackground(buttonText: Constants.submitText)
                        }
                        
                        // Sign in With Google Button
                        Button {
                            // TODO: Future Task
                        } label: {
                            ButtonBackground(buttonText: Constants.signUpWithGoogle)
                        }
                        
                        // Back to Login
                        Button {
                            signInMode = SignInMode.signIn
                        } label: {
                            ButtonBackground(buttonText: Constants.backToLoginTest)
                        }
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, (geo.size.height * 0.25))
                
            }
        
        }
        
    }
    
}

/*
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
*/

