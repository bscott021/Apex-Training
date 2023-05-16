//
//  Program.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/14/23.
//

import Foundation

class Program: Identifiable {
    
    var id:String = ""
    var programName:String = ""
    var programDescription:String = ""
    var numCycles:String = ""
    var workouts:[Workout] = [Workout]()
    
}
