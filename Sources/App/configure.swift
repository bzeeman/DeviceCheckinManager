import Fluent
import FluentPostgresDriver
import Vapor
import DeviceCheckinWatcher

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.http.server.configuration.hostname = "0.0.0.0"

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    
    app.migrations.add(CreateDeviceOwners())
    try app.autoRevert().wait()
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
    app.lifecycle.use(DeviceWatcher())

}
