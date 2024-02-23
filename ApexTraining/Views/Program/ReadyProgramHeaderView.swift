//
//  ReadyProgramHeaderView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 2/10/24.
//

import SwiftUI

struct ReadyProgramHeaderView: View {
    
    @State var readyProgram: Program
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(readyProgram.programName)
                    .font(.title2)
                    .foregroundColor(Color(ApexColors.primary))
                Spacer()
                Text("\(readyProgram.numCycles) Weeks")
                    .font(.caption)
                    .foregroundColor(Color(ApexColors.secondary))
            }
            Text(readyProgram.programDescription)
                .font(.body)
                .foregroundColor(Color(ApexColors.primary))
        }
        
    }
    
}

/*
#Preview {
    ReadyProgramHeaderView()
}
*/
