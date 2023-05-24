//
//  WorkoutView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/16/23.
//

import SwiftUI

struct WorkoutView: View {
    
    // Changing from State to Binding
    @Binding var workout:Workout
    
    var body: some View {
        
        VStack {
            
            // Workout Name
            Text(workout.workoutName)
            
            // List of Exercises
            List(workout.exercises) { e in
                VStack(alignment: .leading) {
                    Text(e.exerciseName)
                    Spacer()
                    Text("0 of \(e.numSets)")
                }
            }
            
        }
        
    }
    
}

/*
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout())
    }
}
*/
