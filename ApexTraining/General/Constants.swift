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
    
    static let submitText = "Submit"
    
    // Tab and Navigation
    static let home = "Home"
    static let homeTabImage = "house"
    static let history = "History"
    static let historyTabImage = "doc"
    
    static let startText = "Start"
    
    enum tabSelectionId {
        case homeView
        case historyView
    }
    
    // Fields
    static let nameText = "Name"
    static let descriptionText = "Description"
    static let numWeeksText = "Number of Weeks"
    
    // Text Field Labels
    static let nameLabel = "Name: "
    static let descriptionLabel = "Description: "
    static let numWeeksLabel = "Number of Weeks: "
    static let numSetsLabel = "Sets: "
    static let numRepsLabel = "Reps: "
    
    // Delete Related
    static let deleteText = "Delete"
    static let deleteImage = "trash"
    
    // Workout Verbage
    static let workoutsText = "Workouts"
    static let addWorkoutText = "Add Workout"
    static let editWorkoutText = "Edit Workout"
    
    // Error
    static let customeErrorTextPrefix = "Custom Error Message: "
    
    // Home View
    static let selectProgramText = "Select a Program"
    static let editProgramsText = "Edit Programs"
    static let editProgramText = "Edit Program"
    static let createProgramText = "Create a Program"
    
    
    
    static let markReadyText = "Ready"
    
    enum programTemplateStatus {
        case Ready
        case Started
        
        var stringValue: String {
            switch self {
                case .Ready:
                    return "Ready"
                case .Started:
                    return "In Progress"
            }
        }
        
    }
    
    static let beginProgramText = "Begin Program"
    
    // MARK: Collections
    static let usersCollection = "users"
    static let programTemplateCollection = "programTemplates"
    static let workoutTemplateCollection = "workoutTemplates"
    static let exerciseSetTemplateCollection = "exerciseSetTemplates"
    static let programsCollection = "programs"
    static let programWorkoutsCollection = "programWorkouts"
    static let exercisesCollection = "exercises"
    
    // Exercise Set
    static let exerciseNameText = "Exercise Name"
    static var numSetsText = "Number of Sets"
    static var numRepsText = "Number of Reps"
    static let exercisesText = "Exercises"
    static let addExercisesText = "Add Exercises"
    static let updateExerciseText = "Update Exercise"
    
    
}
