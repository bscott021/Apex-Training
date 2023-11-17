//
//  HistoryView.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/16/23.
//

import SwiftUI
import FirebaseAuth


struct HistoryView: View {
    
    @EnvironmentObject var model:ApexTrainingModel
    @EnvironmentObject var completedWorkoutModel:WorkoutHistoryModel
    @EnvironmentObject var completedProgramModel:ProgramHistoryModel
     
    @State var tabs = [TabInfo]()
    @State var selectedTab = Tab.Workouts
    
    @State var showSettings = false
    @State var showProfile = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Custom Picker
                VStack {
                    // Tab Buttons
                    HStack (spacing: 0) {
                        Spacer()
                        ForEach(tabs) { tab in
                            HStack {
                                VStack(spacing: 5) {
                                    Text(tab.name)
                                        .font(.title2)
                                    Rectangle()
                                        .foregroundColor(.gray)
                                        .frame(height: 2)
                                        .opacity(tab.view == selectedTab ? 1 : 0)
                                }
                                .foregroundColor(tab.view == selectedTab ? Color.blue : Color.gray)
                                .shadow(radius: tab.view == selectedTab ? 10 : 0)
                                .padding(.top)
                                .frame(height: 80)
                                .onTapGesture {
                                    // Set Selected Tab
                                    self.selectedTab = tab.view
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .frame(height: 80)
                
                // Switch View based on selected tab
                switch(selectedTab) {
                case Tab.Workouts:
                    // Display Completed Workouts
                    WorkoutHistoryView(completedWorkouts: $completedWorkoutModel.completedWorkouts)
                case Tab.Programs:
                    // Show Favorite
                    ProgramHistoryView(completedPrograms: $completedProgramModel.completedPrograms)
                }
                
                Spacer()
                
            }
            .navigationTitle(Constants.historyNavigationText)
            .toolbar {
                // Settings
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings.toggle()
                        }) {
                            Image(systemName: Symbols.settingsImage)
                                .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showSettings) {
                        Text("Settings: TODO")
                    }
                    .onDisappear() {
                        
                    }
                }
                // Logo
                ToolbarItem(placement: .principal) {
                    Image(systemName: Symbols.logoImage)
                }
                // Profile
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfile.toggle()
                        }) {
                            Image(systemName: Symbols.profileImage)
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
            .onAppear() {
                
                // Create Tabs
                var newTabs = [TabInfo]()
                
                newTabs.append(TabInfo(view: Tab.Workouts, name: "Workouts"))
                newTabs.append(TabInfo(view: Tab.Programs, name: "Programs"))
                
                self.tabs = newTabs
                
                // Get Completed Workouts
                self.completedWorkoutModel.getCompletedWorkouts()
                
                // Get Completed Programs
                self.completedProgramModel.getCompletedPrograms()
                
            }
            
        }
        
    }
    
}

/*
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
*/
