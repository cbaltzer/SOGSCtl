import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.routes.get() { req -> HTTPStatus in
        return .ok
    }
    
    try app.register(collection: SOGSController())
}
