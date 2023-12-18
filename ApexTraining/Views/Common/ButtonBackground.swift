//
//  ButtonBackground.swift
//  ApexTraining
//
//  Created by Brendan Scott on 12/15/23.
//

import SwiftUI

struct ButtonBackground: View {
    
    var buttonText: String
    
    var body: some View {
        
        ZStack {
            // Background
            Rectangle()
                .frame(height: 40)
                .foregroundColor(Color(ApexColors.accent))
                .cornerRadius(10)
            // Button Text 
            Text(buttonText)
                .foregroundColor(Color(ApexColors.nearWhite))
                
        }
        
    }
    
}
