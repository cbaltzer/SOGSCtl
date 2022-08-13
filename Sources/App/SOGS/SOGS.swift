//
//  File.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Foundation
import AsyncCommand
import Vapor

struct SOGS {
    private let sogsBin = Environment.get("SOGS_PATH") ?? "/usr/sbin/sogs"

    
    func getRoom(token: String) async throws -> Room {
        let list = Command(name: "list-rooms",
                           command: sogsBin,
                           arguments: [
                            "-L", "-v"
                           ])
        
        try await list.run()
        
        let allRooms = OutputParser().findRooms(log: await list.log)
        
        let targetRoom = allRooms.first { r in
            r.token == token
        }
        
        guard let room = targetRoom else {
            throw Abort(.notFound)
        }
        
        return room
    }
    
    
    func createRoom(token: String, name: String, description: String, admin: String) async throws -> Room {
        let create = Command(name: "create-room",
                             command: sogsBin,
                             arguments: [
                                "--add-room", token,
                                "--name", name,
                                "--description", description
                             ])
        
        try await create.run()
        
        try await addModerator(token: token, moderator: admin, admin: true, hidden: false)
        
        
        let rooms = OutputParser().findRooms(log: await create.log)
        guard let createdRoom = rooms.first(where: { r in
            r.token == token
        }) else  {
            throw Abort(.badRequest)
        }
        
        return createdRoom
    }
    
    
    
    func deleteRoom(token: String) async throws {
        let remove = Command(name: "delete-room",
                             command: sogsBin,
                             arguments: [
                                "--delete-room", token
                             ])
        
        try await remove.run()
    }
    
    
    
    func addModerator(token: String, moderator: String, admin: Bool, hidden: Bool) async throws {
        let addMod = Command(name: "add-mod",
                             command: sogsBin,
                             arguments: [
                                "--rooms", token,
                                "--add-moderators", moderator,
                                "\(hidden ? "--hidden" : "--visible")",
                                "\(admin ? "--admin" : "")"
                             ])
        
        try await addMod.run()
        
        let log = await addMod.log
        if !log.contains("Added \(moderator)") {
            throw Abort(.internalServerError)
        }
    }
    
    
    
    func removeModerator(token: String, moderator: String) async throws {
        let rmMod = Command(name: "rm-mod",
                            command: sogsBin,
                            arguments: [
                                "--rooms", token,
                                "--delete-moderators", moderator,
                            ])
        
        try await rmMod.run()
    }
    
    
}

