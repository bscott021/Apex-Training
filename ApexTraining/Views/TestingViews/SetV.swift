//
//  SetV.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/4/23.
//

import SwiftUI

struct SetV: View {
    
    @ObservedObject var setVM = SetVM()
    
    @State var setNum = ""
    @State var numReps = ""
    @State var weight = ""
    
    var body: some View {
        
        VStack {
            Text("Sets")
            List(setVM.setList) { setL in
                HStack {
                    Text(String(setL.setNum))
                    Text(String(setL.numReps))
                    Text(String(setL.weight))
                    Spacer()
                    // Update Button
                    Button(action: {
                        // Update Set
                        setVM.updateSet(setToUpdate: setL)
                    }, label: {
                        Image(systemName: "pencil")
                    })
                    /*
                    // Delete Set Button
                    Button(action: {
                        // Delete Set
                        setVM.deleteSet(setToDelete: setL)
                    }, label: {
                        Image(systemName: "minus.circle")
                    })
                    */
                }
            }
            Divider()
            VStack() {
                TextField("Set Number: ", text: $setNum)
                TextField("Number of Reps", text: $numReps)
                TextField("Weight", text: $weight)
                Button(action: {
                    // Call addExercise()
                    setVM.addSet(setNum: Int(setNum) ?? 0, numReps: Int(numReps) ?? 0, weight: Int(weight) ?? 0)
                    // Clear text fields
                    setNum = ""
                    numReps = ""
                    weight = ""
                }, label: {
                    Text("Add Set")
                })
            }
            .padding()
        }
        
    }
             
    
    init() {
        setVM.getSets()
    }
    
    
}

struct SetV_Previews: PreviewProvider {
    static var previews: some View {
        SetV()
    }
}
