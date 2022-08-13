//
//  OutputParser.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Foundation

struct OutputParser {
    
    func findRooms(log: String) -> [Room] {
        
        var allRooms: [Room] = []
        
        var currentRoom: Room? = nil
        var hitNewRoom = false
   
        log.enumerateLines { line, stop in
            let line = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // The empty line before a room listing
            if line == "" {
                // starting new room parse
                hitNewRoom = true
                // If it's not the first one
                if let room = currentRoom {
                    allRooms.append(room)
                }
                currentRoom = Room()
                return // go next line
            }
            
            // If the last line was empty, this one is the room token
            if hitNewRoom {
                currentRoom?.token = line
                hitNewRoom = false
                return
            }
            
            if line.hasPrefix("Name:") {
                let parts = line.split(separator: " ")
                if let name = parts.last {
                    currentRoom?.name = String(name)
                }
            }
            
            if line.hasPrefix("Description:") {
                let desc = line.dropFirst("Description: ".count)
                currentRoom?.description = String(desc)
            }
            
            if line.hasPrefix("URL:") {
                let parts = line.split(separator: " ")
                if let url = parts.last {
                    currentRoom?.url = String(url)
                }
            }
        }
        
        // catch the last one
        if let room = currentRoom {
            allRooms.append(room)
        }
        
        print(allRooms)
        
        return allRooms
    }
    
    
}
