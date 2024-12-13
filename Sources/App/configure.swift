import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import JWT
import Gatekeeper

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.http.server.configuration.port = 8081
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "zakFit_db"
    ), as: .mysql)
    
    let fileMiddleware = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(fileMiddleware)
    
    guard let secret = Environment.get("SECRET_KEY") else {
        fatalError("No SECRET_KEY environment variable set")
    }
    
    let hmacKey = HMACKey(from: Data(secret.utf8))
    await app.jwt.keys.add(hmac: hmacKey, digestAlgorithm: .sha256)

    let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin : .all,
    allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
    allowedHeaders: [.accept, .authorization, .contentType, .origin],
    cacheExpiration: 800
    )
    
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    
    app.caches.use(.memory)
    app.gatekeeper.config = .init(maxRequests: 500, per: .minute)
    
    app.middleware.use(GatekeeperMiddleware())
    app.middleware.use(corsMiddleware)
//    app.middleware.use(JSONMiddleware())
    
    // register routes
    try routes(app)
}
