//
//  CustomDividerView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 2/10/24.
//

import SwiftUI

struct CustomDividerView: View {
    
    var body: some View {
        
        ZStack {
            // Background Bar
            Rectangle()
                .foregroundColor(Color(ApexColors.inactive))
                .frame(height: 2)
            Group {
                // Colorful Divider
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 3)
                    .padding(.bottom, 1)
                // Another rectangle to make the bottom corners
                Rectangle()
                    .frame(height: 2)
            }
            .foregroundColor(Color(ApexColors.primary))
            .padding(.horizontal, 5)
        }
        
    }
    
}

#Preview {
    CustomDividerView()

}
