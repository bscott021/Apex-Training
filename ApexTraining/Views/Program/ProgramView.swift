//
//  ProgramView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/13/23.
//

import SwiftUI

struct ProgramView: View {
    
    let user = UserService.shared.user
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var program = Program()
    @State var letUserBegin:Bool
    
    @Binding var currentWorkout:Workout
    @Binding var showProgram:Bool
    @Binding var takeUserToWorkout:Bool
    @Binding var programCompleted:Bool
    
    var body: some View {
        
        GeometryReader { geo in
            
            // Program Header Level Information
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        // Program Name
                        Text(program.programName)
                            .font(.title)
                        Spacer()
                        // Number of Weeks
                        Text("\(program.numCycles) \(Constants.weeksText)")
                            .foregroundColor(Color(ApexColors.secondary))
                            .padding(.top, 5)
                    }
                    
                    // Program Description
                    Text(program.programDescription)
                        .font(.title2)
                    
                }
                .padding([.horizontal, .top], 20)
                
                // List of Workouts and their Exercises
                List(program.workouts) { w in
                    Section(header: WorkoutSectionHeaderView(mainText: w.workoutName, captionText: "\(w.timesCompleted) / \(program.numCycles)")) {
                        
                        ForEach(w.exercises) { w in
                            HStack {
                                Text(w.exerciseName)
                                Spacer()
                                Text("\(w.numSets) sets")
                            }
                        }
                        
                        if letUserBegin == false {
                            // Start Workout Button
                            Button {
                                // Create a new workout in the database and assign it to the current workout. This starts a workout
                                let returnedWorkout = ProgramService.shared.createWorkout(programId: program.id, workout: w)
                                
                                // If we got an id back then it was created in Firestore
                                if returnedWorkout.id != "" {
                                    // Pass returned id instead of w.id
                                    UserService.shared.setCurrentWorkout(workoutDocId: returnedWorkout.id, workoutName: w.workoutName)
                                    self.currentWorkout = returnedWorkout
                                }
                                
                                // Navigate back to Home
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                ButtonBackground(buttonText: Constants.startText)
                                    .frame(height: geo.size.width/5)
                            }
                            .padding(.horizontal, (geo.size.width/5))
                        }
                        
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                // Complete Program Button
                if program.cyclesCompleted >= Int(program.numCycles) ?? 0 {
                    
                    Button {
                        UserService.shared.completeProgram()
                        programCompleted = true
                    } label: {
                        ButtonBackground(buttonText: Constants.completeProgramText)
                            .frame(height: geo.size.width/5)
                    }
                    .padding(.horizontal, (geo.size.width/5))
                    
                }
                
                if letUserBegin {
                    Button {
                        // Set the current Program. This generates the progarm object
                        UserService.shared.beginProgram(programToBegin: program)
                        // Navigate back to Home
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ButtonBackground(buttonText: Constants.beginProgramText)
                            .frame(height: geo.size.width/5)
                    }
                    .padding(.horizontal, (geo.size.width/5))
                }
                
            }
            .foregroundColor(Color(ApexColors.primary))
            
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
