//
//  ExerciseSet.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/14/23.
//

import Foundation

class ExerciseSet: Identifiable {
    
    var id:String = ""
    var exerciseName:String = ""
    var status:String = ""
    var numSets:Int = 0
    var numReps:Int = 0
    var sets:[Set] = [Set]()
    
}
