//
//  WorkoutView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/16/23.
//

import SwiftUI

struct WorkoutView: View {
    
    let user = UserService.shared.user
    
    @EnvironmentObject var currentProgram:ProgramModel
    
    @State var currentWorkout = Workout()

    @State var showProgram = false
    @State var takeUserToWorkout = false
    @State var programReturnedCompleted = false
    
    var computedWorkoutName: String {
        if currentWorkout.workoutName == "" {
            return UserService.shared.user.currentWorktoutName
        }
        else {
            return currentWorkout.workoutName
        }
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            // Workout Name
            Text(currentWorkout.workoutName)
            
            // Custom Divider
            CustomDividerView()
            
            // Grouped list of exercises
            List {
                
                // Completed Group
                Section(header: Text(Constants.completedText)) {
                    ForEach(currentWorkout.exercises) { cwe in
                        if cwe.status == Constants.completedStatus {
                            NavigationLink(destination: ExerciseView(currentWorkout: self.$currentWorkout, currentExercise: cwe).environmentObject(WorkoutModel(workoutIn: self.currentWorkout))) {
                                Text(cwe.exerciseName)
                            }
                        }
                    }
                }

                // Not Started Group
                Section(header: Text(Constants.notStartedText)) {
                    ForEach(currentWorkout.exercises) { cwe in
                        if cwe.status == Constants.notStartedStatus {
                            NavigationLink(destination: ExerciseView(currentWorkout: self.$currentWorkout, currentExercise: cwe).environmentObject(WorkoutModel(workoutIn: self.currentWorkout))) {
                                Text(cwe.exerciseName)
                            }
                        }
                    }
                }
                
                // In Progress Group
                Section(header: Text(Constants.inProgressText)) {
                    ForEach(currentWorkout.exercises) { cwe in
                        if cwe.status == Constants.inProgressStatus {
                            NavigationLink(destination: ExerciseView(currentWorkout: self.$currentWorkout, currentExercise: cwe).environmentObject(WorkoutModel(workoutIn: self.currentWorkout))) {
                                Text(cwe.exerciseName)
                            }
                        }
                    }
                }
                
            }
            .listStyle(InsetListStyle())
            
            // Complete Workout Button
            if (currentWorkout.status == Constants.inProgressStatus) {
                Button {
                    // Complete the workout
                    UserService.shared.completeWorkout(workoutDocId: currentWorkout.id, workoutName: currentWorkout.workoutName)
                } label: {
                    ButtonBackground(buttonText: Constants.completeText)
                }
            }
            
            // View Current Program Button
            Button() {
                showProgram.toggle()
            } label: {
                ButtonBackground(buttonText: UserService.shared.user.currentProgramName)
            }
            .sheet(isPresented: $showProgram) {
                ProgramView(program: currentProgram.currentProgram, letUserBegin: false, currentWorkout: $currentWorkout, showProgram: $showProgram, takeUserToWorkout: $takeUserToWorkout, programCompleted: $programReturnedCompleted).onDisappear() {
                    if programReturnedCompleted == true {
                        // Clear the values
                        currentProgram.currentProgram = Program()
                        currentWorkout = Workout()
                        UserService.shared.getCurrentProgramInfo()
                        user.currentProgramId = ""
                    }
                }
            }
            .onAppear {
                if user.currentProgramId != "" {
                    currentProgram.getProgram(programDocIdToGet: user.currentProgramId)
                }
            }
            
        }
        .padding(.horizontal, 20)
        
    }
    
}

/*
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: Workout())
    }
}
*/
