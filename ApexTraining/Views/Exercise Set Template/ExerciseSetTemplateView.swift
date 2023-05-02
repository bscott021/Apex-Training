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
            Form {
                TextField(Constants.exerciseNameText, text: $exerciseName)
                TextField(Constants.numSetsText, text: $numSets)
                TextField(Constants.numRepsText, text: $numReps)
            }

        }
        
    }
    
}


/*
struct ExerciseSetTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSetTemplateView()
    }
}
*/
