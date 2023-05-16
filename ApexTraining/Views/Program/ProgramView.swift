//
//  ProgramView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/13/23.
//

import SwiftUI

struct ProgramView: View {
    
    @State var program = Program()
    @State var letUserBegin:Bool
    
    var body: some View {
        
        // Program Header Level Information
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading) {
                    // Program Name
                    Text(program.programName)
                        .font(.title)
                    
                    // Program Description
                    Text(program.programDescription)
                        .font(.title2)
                    
                    // Number of Weeks
                    Text("\(program.numCycles) Weeks")
                }
                
                Spacer()
                if letUserBegin {
                    Button {
                        // Set the current Program. This generates the progarm object
                        UserService.shared.beginProgram(programToBegin: program)
                        
                    } label: {
                        Text(Constants.beginProgramText)
                    }
                }
            }
            .padding(20)
            
            // List of Workouts and their Exercises
            List(program.workouts) { w in
                Section(header: Text(w.workoutName)) {
                    // This should be for setting the current workout. Needs modification
                    /*Button {
                        // Set the currewnt workout
                        UserService.shared.beginProgram(programToBegin: program)
                        
                    } label: {
                        Text("Begin")
                    }*/
                    ForEach(w.exercises) { w in
                        HStack {
                            Text(w.exerciseName)
                            Spacer()
                            Text("\(w.numSets) sets")
                        }
                    }
                }
            }
            
        }
        
    }
    
}

/*
struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView()
    }
}
*/
