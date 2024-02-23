//
//  WorkoutSectionHeaderView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 2/7/24.
//

import SwiftUI

struct WorkoutSectionHeaderView: View {
    
    var mainText: String
    var captionText: String
    
    var body: some View {
        
        HStack {
            Text(mainText)
                .font(.title3)
            Spacer()
            Text(captionText)
                .font(.caption)
        }
        .foregroundColor(Color(ApexColors.primary))
        
    }
    
}

/*
 #Preview {
 WorkoutSectionHeaderView()
 }
 */
