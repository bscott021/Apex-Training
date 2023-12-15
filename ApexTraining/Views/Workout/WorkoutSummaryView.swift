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
        
        VStack(alignment: .center, spacing: 10) {
            
            // Date Completed
            Text(workoutToView.dateTimeCompleted, format: .dateTime.day().month().year())
                .padding(.leading)
                .foregroundColor(Color(ApexColors.secondary))
                .font(.body)
   
            // Exercises List
            List(workoutToView.exercises) { e in
                Section(header: Text(e.exerciseName).foregroundColor(Color(ApexColors.secondary))) {
                    HStack {
                        // Set Texts 
                        Text(Constants.setText)
                            .font(.caption)
                        Spacer()
                        // Reps Text
                        Text(Constants.repsText)
                            .font(.caption)
                        Spacer()
                        // Weight Used Text
                        Text(Constants.weightText)
                            .font(.caption)
                    }
                    ForEach(e.sets.sorted { $0.setNum < $1.setNum } ) { s in
                        HStack {
                            // Set Value
                            Text(String(s.setNum))
                            Spacer()
                            // Number of Reps
                            Text(String(s.numReps))
                            Spacer()
                            // Weight Used
                            Text(String(s.weight))
                        }
                    }
                }
                .foregroundColor(Color(ApexColors.primary))
            }
            .listStyle(PlainListStyle())
            .padding(.trailing)
            
            Spacer()
            
        }
        .navigationBarTitle(workoutToView.workoutName, displayMode: .inline)
        
    }
    
}

/*
struct WorkoutSummaryView_Previews: PreviewProvider {
 static var previews: some View {
  WorkoutSummaryView()
 }
}*/
