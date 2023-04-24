//
//  HomeView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    
    @ObservedObject var startedTemplatesModel = StartedTemplatesModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(Constants.editProgramsText)
                    .font(.title)
                
                // List of "Started Templates"
                List (startedTemplatesModel.startedTemplates) { pt in
                    NavigationLink(destination: ProgramTemplateView().environmentObject(ProgramTemplateModel(docId: pt.id))) {
                        VStack(alignment: .leading) {
                            Text(pt.programName)
                                .font(.title2)
                            Text(pt.programDescription)
                                .font(.body)
                        }
                    }
                }
                .onAppear {
                    startedTemplatesModel.getProgramTemplates()
                }
                
                Spacer()
                
                // Link to "Create a Program"
                ZStack {
                    
                    Rectangle()
                        .frame(height: 40)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                        .padding(20)
                    
                    // Button to create a new ProgramTemplate
                    NavigationLink(destination: ProgramTemplateView().environmentObject(ProgramTemplateModel()), label: {
                        Text(Constants.createProgramText)
                    })
                    .environmentObject(model)
                    .foregroundColor(.white)
                     
                }
                
                
            }
            .navigationTitle(Constants.home)
            .navigationBarItems(trailing:
                // "Sign Out" Button
                Button {
                    try! Auth.auth().signOut()
                    model.checkSignIn()
                } label: {
                    Text(Constants.signOut)
                }
            )
            
        }
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
