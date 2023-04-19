//
//  Constants.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import Foundation

struct Constants {
    
    // User
    static let signIn = "Sign In"
    static let signOut = "Sign Out"
    static let createAccount = "Create Account"
    
    static let email = "Email"
    static let name = "Name"
    static let password = "Password"
    
    enum signInMode {
        case signIn
        case createAccount
    }
    
    // Tab and Navigation
    static let home = "Home"
    static let homeTabImage = "house"
    static let history = "History"
    static let historyTabImage = "doc"
    
    enum tabSelectionId {
        case homeView
        case historyView
    }
    
}
