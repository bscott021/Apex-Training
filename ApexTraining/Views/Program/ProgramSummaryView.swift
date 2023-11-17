//
//  ProgramSummaryView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 9/13/23.
//

import SwiftUI

struct ProgramSummaryView: View {
    
    @State var completedProgram: Program
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading, spacing: 10) {
                // Program Name
                Text(completedProgram.programName)
                    .font(.title)
                
                // Program Description
                Text(completedProgram.programDescription)
                    .font(.body)
                
                // Status
                Text(completedProgram.status)
                    .font(.callout)
                    .fontWeight(.bold)
                
                // Completed vs Cycles
                Text("\(completedProgram.cyclesCompleted)/\(completedProgram.numCycles)")
                    .font(.callout)
                    .fontWeight(.bold)
            }
            .padding(.leading)
            
            // Title
            Text(Constants.completedWorkoutsText)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading)
            
            // List of Completed Workouts
            List(completedProgram.workouts) { w in
                NavigationLink(destination: WorkoutSummaryView(workoutToView: ProgramService.shared.getWorkout(workoutDocIdToGet: w.id))) {
                    HStack {
                        Text(w.workoutName)
                        Spacer()
                        Text(w.dateTimeCompleted, format: .dateTime.day().month().year())
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.trailing)
        
        }
        
    }
    
    
}

/*
struct ProgramSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramSummaryView()
    }
}
*/
