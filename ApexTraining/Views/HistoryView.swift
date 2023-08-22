//
//  HistoryView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var completedWorkoutModel:WorkoutHistoryModel
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                // Display Completed Workouts
                WorkoutHistoryView(completedWorkouts: $completedWorkoutModel.completedWorkouts)
            }
            .onAppear() {
                self.completedWorkoutModel.getCompletedWorkouts()
            }
            
        }
        .navigationBarTitle(Constants.historyNavigationText)
        
    }
    
}

/*
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
*/
