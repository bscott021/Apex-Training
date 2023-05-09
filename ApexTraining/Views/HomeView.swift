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
    @EnvironmentObject var startedTemplatesModel:StartedTemplatesModel
    @EnvironmentObject var readyTemplatesModel:ReadyTemplatesModel
    
    @State var showingProgramTemplateView = false
    @State var showingNewProgramTemplateView = false
    @State var hideHomeNavBar = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Select Program from "Ready" programs
                Text(Constants.selectProgramText)
                    .font(.title2)
                
                // List of programs that are in a Ready status
                List (readyTemplatesModel.readyTemplates) { rpt in
                    //Text(rpt.programName)
                    NavigationLink(destination: Text("Todo")) {
                        VStack(alignment: .leading) {
                            Text(rpt.programName)
                                .font(.title2)
                            //Text(pt.programDescription).font(.body)
                        }
                    }
                }
                
                // Started Programs
                Text(Constants.editProgramsText)
                    .font(.title2)
                
                // List of "Started Templates"
                List (startedTemplatesModel.startedTemplates) { pt in
                    
                    NavigationLink(destination: ProgramTemplateView(programTemplateModel: ProgramTemplateModel(programTemplateDocId: pt.id))) {
                        VStack(alignment: .leading) {
                            Text(pt.programName)
                                .font(.title2)
                            Text(pt.programDescription)
                                .font(.body)
                        }
                    }

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
                    VStack {
                        NavigationLink(destination: ProgramTemplateView(programTemplateModel: ProgramTemplateModel()), isActive: $showingNewProgramTemplateView) { EmptyView() }
                        Button(Constants.createProgramText) {
                            self.showingNewProgramTemplateView = true
                        }
                        .foregroundColor(.white)
                    }
                }
                
                
            }
            //.navigationViewStyle(.stack)
            .navigationTitle(Constants.home)
            .navigationBarHidden(hideHomeNavBar)
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
        .onAppear {
            startedTemplatesModel.getProgramTemplates()
            readyTemplatesModel.getReadyProgramTemplates()
        }
        
    }
    
}

/*
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
*/
