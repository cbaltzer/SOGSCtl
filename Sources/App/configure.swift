import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    // DB init
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    
    // Migrations
    app.migrations.add(CreateAPIKey())

    
    // Leaf init
    app.views.use(.leaf)
    
    
    // Commands
    app.commands.use(AddKey(), as: "add-key")
    

    // register routes
    try routes(app)
}
