//
//  Room.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Foundation
import Vapor

struct Room: Content {
    var token: String?
    var name: String?
    var description: String?
    var url: String?
    var admin: String?
}


extension Room: Validatable {
    
    static func validations(_ validations: inout Validations) {
        validations.add("token", as: String.self, is: .count(2...)) // dont allow "+" or "*"
        validations.add("token", as: String.self, is: .alphanumeric)
        validations.add("name", as: String.self, is: .count(2...))
        validations.add("description", as: String.self, is: .count(1...))
        validations.add("admin", as: String.self, is: .count(65...67) )
        validations.add("admin", as: String.self, is: .alphanumeric)
    }
    
}
