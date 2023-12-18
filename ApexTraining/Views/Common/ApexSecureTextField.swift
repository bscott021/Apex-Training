//
//  ApexSecureTextField.swift
//  ApexTraining
//
//  Created by Brendan Scott on 12/17/23.
//

import SwiftUI

struct ApexSecureTextField: View {
    
    @Binding var field: String
    
    var labelText: String
    var image: String
    
    var body: some View {
        
        ZStack {
            // Background 
            Rectangle()
                .frame(height: 40)
                .foregroundColor(Color(ApexColors.nearWhite))
                .cornerRadius(10)
            HStack {
                // Icon Image
                Image(systemName: image)
                // Secure Text Field 
                SecureField(labelText, text: $field)
                    .disableAutocorrection(true)
                    .foregroundColor(Color(ApexColors.primary))
            }
            .padding(.all, 10)
            .foregroundColor(Color(ApexColors.secondary))
            
        }

    }
    
}

