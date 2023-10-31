//
//  TemplateView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 10/30/23.
//

import SwiftUI
import FirebaseAuth

struct TemplateView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @EnvironmentObject var startedTemplatesModel:StartedTemplatesModel
    
    @State var showingNewProgramTemplateView = false
    
    @State var showSettings = false
    @State var showProfile = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Edit or Create a Program
                HStack {
                    // Edit Programs
                    Text(Constants.editProgramsText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Link to "Create a Program"
                    VStack {
                        NavigationLink(destination: ProgramTemplateView(programTemplateModel: ProgramTemplateModel()), isActive:$showingNewProgramTemplateView) { EmptyView() }
                        Button(Constants.createProgramText) {
                            self.showingNewProgramTemplateView = true
                        }
                    }
                }
                .padding(.horizontal)
                
                
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
                .listStyle(PlainListStyle())
                
            }
            .navigationTitle(Constants.templates)
            .toolbar {
                // Settings
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings.toggle()
                        }) {
                            Image(systemName: Constants.settingsImage)
                                .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showSettings) {
                        Text("Settings: TODO")
                    }
                }
                // Logo
                ToolbarItem(placement: .principal) {
                    Image(systemName: Constants.logoImage)
                }
                // Profile
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfile.toggle()
                        }) {
                            Image(systemName: Constants.profileImage)
                                .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showProfile) {
                        VStack {
                            Text("Profile: TODO")
                            // "Sign Out" Button
                            Button {
                                try! Auth.auth().signOut()
                                model.checkSignIn()
                            } label: {
                                Text(Constants.signOut)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.startedTemplatesModel.getProgramTemplates()
        }
        
        
        
    }
    
}

struct TemplateView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateView()
    }
}
