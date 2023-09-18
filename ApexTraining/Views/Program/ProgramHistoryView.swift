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
            
            // Title
            Text("Completed Programs")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading)
            
            // List of Completed Programs
            List(completedPrograms) { cp in
                NavigationLink(destination: ProgramSummaryView(completedProgram : cp)) {
                    HStack {
                        VStack (alignment: .leading) {
                            Text(cp.programName)
                            Spacer()
                            Text("\(cp.cyclesCompleted)/\(cp.numCycles)")
                        }
                        .padding(.vertical)
                        Text(cp.programDescription)
                    }
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
