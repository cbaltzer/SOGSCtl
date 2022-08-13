//
//  AddKey.swift
//  
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Vapor

struct AddKey: Command {
    struct Signature: CommandSignature { }

    var help: String {
        "Adds a new API key"
    }

    func run(using context: CommandContext, signature: Signature) throws {
        let db = context.application.db
        let key = APIKey(generateKey: true)
        
        do {
            try key.save(on: db).wait()
            print("Created API key: \(key.key)")
        } catch {
            print("Error creating key: \(error)")
        }
    }
}
