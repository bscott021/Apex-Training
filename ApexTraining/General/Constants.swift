//
//  Constants.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import Foundation

struct Constants {
    
    // MARK: User
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
    
    // MARK: Tab and Navigation
    static let home = "Home"
    static let homeTabImage = "house"
    static let history = "History"
    static let historyTabImage = "doc"
    
    enum tabSelectionId {
        case homeView
        case historyView
    }
    
    // MARK: General
    
    // Fields
    static let nameText = "Name"
    static let descriptionText = "Description"
    static let numWeeksText = "Number of Weeks"
    
    // Error
    static let customeErrorTextPrefix = "Custom Error Message: "
    
    // MARK: Home View
    static let editProgramsText = "Edit Programs"
    static let editProgramText = "Edit Program"
    static let createProgramText = "Create a Program"
    
    // MARK: Program Template
    // Collections
    static let programTemplateCollection = "programTemplates"
    
    
    
}
