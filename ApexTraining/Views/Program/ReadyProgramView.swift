//
//  ReadyProgramView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 2/10/24.
//

import SwiftUI

struct ReadyProgramView: View {
    
    @EnvironmentObject var readyTemplatesModel:ReadyTemplatesModel
    
    @State var currentWorkout = Workout()
    
    @State var programReturnedCompleted = false
    @State var showProgram = false
    @State var takeUserToWorkout = false
    @State var showExercise = false
    
    var body: some View {
        
        VStack(alignment: .center) {
            // Select Program from "Ready" programs
            Text(Constants.selectProgramText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(ApexColors.primary))
            
            // Custom Divider
            CustomDividerView()
            
            // List of programs that are in a Ready status
            List (readyTemplatesModel.readyPrograms) { rp in
                
                NavigationLink(destination: ProgramView(program: rp, letUserBegin: true, currentWorkout: $currentWorkout, showProgram: $showProgram, takeUserToWorkout: $takeUserToWorkout, programCompleted: $programReturnedCompleted)) {
                    ReadyProgramHeaderView(readyProgram: rp)
                }
                
            }
            .listStyle(PlainListStyle())
            
        }
            
    }
    
}

/*
#Preview {
    ReadyProgramView()
}
*/

