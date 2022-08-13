//
//  Moderator.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Foundation
import Vapor

struct Moderator: Content {
    var id: String?
    var hidden: Bool? = false
    var admin: Bool? = false
}


extension Moderator: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: String.self, is: .alphanumeric)
        validations.add("id", as: String.self, is: .count(65...67))
        validations.add("hidden", as: Bool.self)
        validations.add("admin", as: Bool.self)
    }
}
