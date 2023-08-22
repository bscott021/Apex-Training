//
//  WorkoutSummaryView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 8/20/23.
//

import SwiftUI

struct WorkoutSummaryView: View {
    
    @State var workoutToView:Workout
    
    var body: some View {
        
        VStack {
            
            // Workout Name
            Text(workoutToView.workoutName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading)
            
            // Date Completed
            Text(workoutToView.dateTimeCompleted, format: .dateTime.day().month().year())
                .font(.callout)
                .fontWeight(.bold)
                .padding(.leading)
            
            // Exercises List
            List(workoutToView.exercises) { e in
                Section(header: Text(e.exerciseName)) {
                    ForEach(e.sets) { s in
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 30, height: 30)
                                Text(String(s.setNum))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            Text("\(s.numReps) x \(s.weight)")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            
        }
        
    }
    
}

/*
struct WorkoutSummaryView_Previews: PreviewProvider {
 static var previews: some View {
  WorkoutSummaryView()
 }
}*/
