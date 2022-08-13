//
//  APIKey.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Fluent
import Vapor
import Foundation

final class APIKey: Model, Content, Authenticatable {
    static let schema = "api_keys"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "key")
    var key: String
    
    init() { }

    init(id: UUID? = nil, generateKey: Bool) {
        self.id = id
        self.key = self.generateKey()
    }
    
    func generateKey() -> String {
        let uuid = UUID().uuidString
        let key = uuid.replacingOccurrences(of: "-", with: "").lowercased()
        return key
    }
}



struct ValidateAPIKeyMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        
        guard let bearer = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        let key = try await APIKey.query(on: request.db).filter(\.$key == bearer.token).first()
        if key == nil {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
