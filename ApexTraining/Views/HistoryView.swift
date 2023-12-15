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
                
                // Tab Buttons
                HStack (spacing: 0) {
                    ForEach(tabs) { tab in
                        VStack {
                            // Tab Name
                            Text(tab.name)
                                .font(.title)
                            ZStack {
                                // Divider
                                Rectangle()
                                    .foregroundColor(Color(ApexColors.inactive))
                                    .frame(height: 3)
                                    .opacity(tab.view == selectedTab ? 0 : 1)
                                // Selection Indicator
                                RoundedRectangle(cornerRadius: 3)
                                    .foregroundColor(Color(ApexColors.primary))
                                    .frame(height: 6)
                                    .opacity(tab.view == selectedTab ? 1 : 0)
                                    .padding(.bottom, 3)
                                // Another rectangle to make the bottom corners
                                Rectangle()
                                    .foregroundColor(Color(ApexColors.primary))
                                    .frame(height: 3)
                                    .opacity(tab.view == selectedTab ? 1 : 0)
                            }
                        }
                        .foregroundColor(tab.view == selectedTab ? Color(ApexColors.primary) : Color(ApexColors.inactive))
                        .onTapGesture {
                            // Set Selected Tab
                            self.selectedTab = tab.view
                        }
                    }
                }
                
                // Switch View based on selected tab
                switch(selectedTab) {
                case Tab.Workouts:
                    // Display Completed Workouts
                    WorkoutHistoryView(completedWorkouts: $completedWorkoutModel.completedWorkouts)
                case Tab.Programs:
                    // Show Favorite
                    ProgramHistoryView(completedPrograms: $completedProgramModel.completedPrograms)
                }
                
            }
            .navigationBarTitle(ApexColors.primary, displayMode: .inline)
            .toolbar {
                ToolBarView(showSettings: $showSettings, showProfile: $showProfile)
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
