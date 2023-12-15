//
//  WorkoutHistoryView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 8/20/23.
//

import SwiftUI

struct WorkoutHistoryView: View {
    
    @Binding var completedWorkouts:[Workout]
    
    var body: some View {
        
        VStack {
            
            // List of Completed Workouts
            List(completedWorkouts.sorted { $0.dateTimeCompleted > $1.dateTimeCompleted } ) { cw in
                NavigationLink(destination: WorkoutSummaryView(workoutToView: ProgramService.shared.getWorkout(workoutDocIdToGet: cw.id))) {
                    HStack {
                        // Workout Name
                        Text(cw.workoutName)
                            .font(.subheadline)
                        Spacer()
                        // Completion Date
                        Text(cw.dateTimeCompleted, format: .dateTime.day().month().year())
                            .font(.caption)
                    }
                    .foregroundColor(Color(ApexColors.secondary))
                }
            }
            .listStyle(PlainListStyle())
            
        }
        
        
    }
    
}

/*
struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
    }
}
*/

