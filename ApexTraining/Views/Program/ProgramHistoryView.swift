//
//  ProgramHistoryView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 9/13/23.
//

import SwiftUI

struct ProgramHistoryView: View {
    
    @Binding var completedPrograms:[Program]
    
    var body: some View {
        
        VStack {
            
            // List of Completed Programs
            List(completedPrograms) { cp in
                NavigationLink(destination: ProgramSummaryView(completedProgram : cp)) {
                    VStack (alignment: .leading) {
                        HStack {
                            // Program Name
                            Text(cp.programName)
                                .font(.title3)
                                .foregroundColor(Color(ApexColors.primary))
                                .padding(.bottom, 2)
                            Spacer()
                            // Number of Weeks
                            Text("\(cp.cyclesCompleted)/\(cp.numCycles)")
                                .foregroundColor(Color(ApexColors.secondary))
                                .font(.caption)
                        }
                        // Program Description
                        Text(cp.programDescription)
                            .font(.body)
                            .foregroundColor(Color(ApexColors.primary))
                            .padding(.bottom)
                    }
                    .padding(.trailing)
                }
            }
            .listStyle(PlainListStyle())
            .padding(.trailing)
            
        }
        
    }
    
}

/*
struct ProgramHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
    }
}
*/
