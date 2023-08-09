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
    var cyclesCompleted:Int = 0
    var workouts:[Workout] = [Workout]()
    
}
