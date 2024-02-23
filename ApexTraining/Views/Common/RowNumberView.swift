//
//  RunNumberView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 2/10/24.
//

import SwiftUI

struct RowNumberView: View {
    
    var rowNumber: Int
    
    var body: some View {
        
        ZStack {
            // Row Indicator
            Circle()
                .fill(Color(ApexColors.accent))
                .frame(width: 30, height: 30)
            // Row Number
            Text(String(rowNumber))
                .foregroundColor(Color(ApexColors.nearWhite))
                .fontWeight(.bold)            
        }
        
    }
    
}

#Preview {
    RowNumberView(rowNumber: 1)
}
