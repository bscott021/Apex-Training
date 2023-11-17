//
//  ProgramTemplateStatus.swift
//  ApexTraining
//
//  Created by Brendan Scott on 11/17/23.
//

import Foundation

enum ProgramTemplateStatus {
    
    case Ready
    case Started
    var stringValue: String {
        
        switch self {
            case .Ready:
                return "Ready"
            case .Started:
                return "In Progress"
        }
        
    }
    
}
