//
//  Workout.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/14/23.
//

import Foundation

class Workout: Identifiable {
    
    var id:String = ""
    var workoutName:String = ""
    var dateTimeCompleted:Date = Date()
    var timesCompleted:Int = 0
    var exercises:[ExerciseSet] = [ExerciseSet]()
    
}
