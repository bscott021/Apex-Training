//
//  ProgramTemplateView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/18/23.
//

import SwiftUI

struct ProgramTemplateView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @EnvironmentObject var programTemplateModel:ProgramTemplateModel
    
    @State var programName = ""
    @State var programDescription = ""
    @State var numberOfWeeks = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Form to enter the program template high level data
                Form {
                    TextField(Constants.nameText, text: $programName)
                    TextField(Constants.descriptionText, text: $programDescription)
                    TextField(Constants.numWeeksText, text: $numberOfWeeks)
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .navigationTitle(Constants.editProgramText)
        }
        .onAppear {
            // Assign state properties to retrieved properites
            programName = programTemplateModel.programTemplate.programName
            programDescription = programTemplateModel.programTemplate.programDescription
            numberOfWeeks = programTemplateModel.programTemplate.numCycles
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {
            _ in
            programTemplateModel.saveProgramTemplate(saveDB: true, name: programName, description: programDescription, numWeeks: numberOfWeeks)
        }
        
    }
    
}

struct ProgramTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramTemplateView()
    }
}
