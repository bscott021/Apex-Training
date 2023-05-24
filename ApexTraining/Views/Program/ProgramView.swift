//
//  ProgramView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/13/23.
//

import SwiftUI

struct ProgramView: View {
    
    let user = UserService.shared.user
    
    @State var program = Program()
    @State var letUserBegin:Bool
    
    @Binding var currentWorkout:Workout
    @Binding var showProgram:Bool
    @Binding var takeUserToWorkout:Bool
    
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
                    // This sets the current workout
                    if letUserBegin == false {
                        Button {
                            // Set the current workout if this is a Start. This doesn't need to happen to Resume
                            UserService.shared.setCurrentWorkout(workoutDocId: w.id, workoutName: w.workoutName)
                            self.currentWorkout = w
                            self.takeUserToWorkout = true
                            self.showProgram = false
                            
                        } label: {
                            Text(Constants.startText)
                        }
                    }
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
