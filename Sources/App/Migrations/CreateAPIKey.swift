//
//  CreateAPIKey.swift
//
//
//  Created by Christopher Baltzer on 2022-08-12.
//

import Fluent

struct CreateAPIKey: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("api_keys")
            .id()
            .field("key", .string, .required)
            .unique(on: "key")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("api_keys").delete()
    }
}
