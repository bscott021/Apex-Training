//
//  ExerciseSetTemplateView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 5/1/23.
//

import SwiftUI

struct ExerciseSetTemplateView: View {
    
    @State var heading:String
    @Binding var exerciseName:String
    @Binding var numSets:String
    @Binding var numReps:String
    
    var body: some View {
        
        VStack {
            Text(heading)
                .font(.title2)
                .fontWeight(.bold)
            List {
                // Exercise Name
                HStack {
                    Text(Constants.nameLabel)
                    TextField(Constants.exerciseNameText, text: $exerciseName)
                }
                // Number of Sets
                HStack {
                    Text(Constants.numSetsLabel)
                    TextField(Constants.numSetsText, text: $numSets)
                }
                // Number of Reps
                HStack {
                    Text(Constants.numRepsLabel)
                    TextField(Constants.numRepsText, text: $numReps)
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top)
        
    }
    
}


/*
struct ExerciseSetTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSetTemplateView()
    }
}
*/
