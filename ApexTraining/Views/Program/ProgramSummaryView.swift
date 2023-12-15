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
                
                HStack {
                    
                    // Program Name
                    Text(completedProgram.programName)
                        .font(.title)
                        .foregroundColor(Color(ApexColors.primary))
                    
                    Spacer()
                    
                    // Completed vs Cycles
                    Text("\(completedProgram.cyclesCompleted)/\(completedProgram.numCycles)")
                        .font(.caption)
                        .foregroundColor(Color(ApexColors.secondary))
                    
                    // Status
                    Text(completedProgram.status)
                        .foregroundColor(Color(ApexColors.secondary))
                        .font(.caption)
                    
                }
                
                // Program Description
                Text(completedProgram.programDescription)
                    .foregroundColor(Color(ApexColors.primary))
                    .font(.body)
                
            }
            .padding(.leading)
            
            // List of Completed Workouts
            List(completedProgram.workouts.sorted { $0.dateTimeCompleted > $1.dateTimeCompleted } ) { w in
                NavigationLink(destination: WorkoutSummaryView(workoutToView: ProgramService.shared.getWorkout(workoutDocIdToGet: w.id))) {
                    HStack {
                        // Workout Name
                        Text(w.workoutName)
                            .font(.subheadline)
                            .foregroundColor(Color(ApexColors.primary))
                        Spacer()
                        // Completion Date
                        Text(w.dateTimeCompleted, format: .dateTime.day().month().year())
                            .font(.caption)
                            .foregroundColor(Color(ApexColors.secondary))
                    }
                }
            }
            .listStyle(PlainListStyle())
        
        }
        .padding(.trailing)
        
    }
    
    
}

/*
struct ProgramSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramSummaryView()
    }
}
*/
