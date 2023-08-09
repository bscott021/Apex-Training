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
    @Binding var programCompleted:Bool
    
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
                    Text("\(program.numCycles) Total Weeks")
                    
                    // Complete Program Button
                    if program.cyclesCompleted >= Int(program.numCycles) ?? 0 {
                        Button("Complete Program") {
                            UserService.shared.completeProgram()
                            programCompleted = true
                            showProgram = false
                        }
                    }
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
                        HStack {
                            // Start Workout Button
                            Button {
                                // Create a new workout in the database and assign it to the current workout. This starts a workout
                                let returnedWorkout = UserService.shared.createWorkout(workout: w)
                                
                                // If we got an id back then it was created in Firestore
                                if returnedWorkout.id != "" {
                                    // Pass returned id instead of w.id
                                    UserService.shared.setCurrentWorkout(workoutDocId: returnedWorkout.id, workoutName: w.workoutName)
                                    self.currentWorkout = returnedWorkout
                                    self.takeUserToWorkout = true
                                    self.showProgram = false
                                }
                            } label: {
                                Text(Constants.startText)
                            }
                            
                            Spacer()
                            
                            // Completion Count
                            Text("\(w.timesCompleted) / \(program.numCycles)")
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
