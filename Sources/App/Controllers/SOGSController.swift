//
//  SOGSController.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Foundation
import Vapor
import Fluent

struct SOGSController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let authn = routes.grouped([
            ValidateAPIKeyMiddleware()
        ])
        
        let sogs = authn.grouped("room")
        
        sogs.get(":room", use: roomDetails)
        sogs.post(use: createRoom)
        sogs.delete(":room", use: deleteRoom)
        
        sogs.post(":room", "moderator", use: addMod)
        sogs.delete(":room", "moderator", use: deleteMod)
    }

    
    func roomDetails(req: Request) async throws -> Room {
        guard let token = req.parameters.get("room") else {
            throw Abort(.notFound)
        }
        
        let room = try await SOGS().getRoom(token: token)
        return room
    }

    
    func createRoom(req: Request) async throws -> Room {
        try Room.validate(content: req)
        let room = try req.content.decode(Room.self)
            
        let newRoom = try await SOGS().createRoom(token: room.token!,
                                                  name: room.name!,
                                                  description: room.description ?? "",
                                                  admin: room.admin!)
        
        return newRoom
    }
    
    
    func deleteRoom(req: Request) async throws -> HTTPStatus {
        guard let token = req.parameters.get("room") else {
            throw Abort(.notFound)
        }
        
        try await SOGS().deleteRoom(token: token)
        return .ok
    }
    
    
    func addMod(req: Request) async throws -> HTTPStatus {
        guard let token = req.parameters.get("room") else {
            throw Abort(.notFound)
        }
        try Moderator.validate(content: req)
        let mod = try req.content.decode(Moderator.self)
        
        try await SOGS().addModerator(token: token,
                                      moderator: mod.id!,
                                      admin: mod.admin ?? false,
                                      hidden: mod.hidden ?? false)
        
        return .ok
    }
    
    
    func deleteMod(req: Request) async throws -> HTTPStatus {
        guard let token = req.parameters.get("room") else {
            throw Abort(.notFound)
        }
        try Moderator.validate(content: req)
        let mod = try req.content.decode(Moderator.self)
        
        try await SOGS().removeModerator(token: token, moderator: mod.id!)
        return .ok
    }

}

