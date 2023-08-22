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
            
            // Title
            Text(Constants.completedWorkoutsText)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading)
            
            // List of Completed Workouts
            List(completedWorkouts) { cw in
                NavigationLink(destination: WorkoutSummaryView(workoutToView: UserService.shared.getWorkout(workoutDocIdToGet: cw.id))) {
                    HStack {
                        Text(cw.workoutName)
                        Spacer()
                        Text(cw.dateTimeCompleted, format: .dateTime.day().month().year())
                    }
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

