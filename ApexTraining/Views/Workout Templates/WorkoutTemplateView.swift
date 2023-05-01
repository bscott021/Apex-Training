//
//  WorkoutTemplateView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/23/23.
//

import SwiftUI

struct WorkoutTemplateView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @ObservedObject var workoutTemplateModel:WorkoutTemplateModel
    
    @State var workoutName = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text(Constants.editWorkoutText)
                    .font(.title2)
                Form {
                    TextField(Constants.nameText, text: $workoutName)
                }
                Spacer()
            }
        }
        .navigationTitle(Constants.editWorkoutText)
        .onAppear {
            workoutName = workoutTemplateModel.workoutTemplate.workoutName
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
            _ in
            workoutTemplateModel.saveWorkoutTemplate(saveDB: true, name: workoutName)
        }
        
    }
    
    
}

/*
struct WorkoutTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTemplateView()
    }
}
*/
