//
//  UserService.swift
//  ApexTraining
//
//  Created by Brendan Scott on 4/17/23.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
    
}
