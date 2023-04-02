import Fluent
import Vapor
import DeviceCheckinWatcher
import Foundation

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("connectedDevices") { req async -> String in
        let idDevices = await USBManager.actor.devices
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(idDevices), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        } else {
            return "{}"
        }
    }

    app.post("registerOwner") { req async -> HTTPStatus in 
        guard let newOwner = try? req.content.decode(DeviceOwner.self) else {
            return HTTPStatus.badRequest
        }
        let database = req.db
        if let owners = try? await database.query(DeviceOwner.self)
            .filter(\.$firstName == newOwner.firstName)
            .all()  {
                if owners.count > 0 {
                    if owners.contains(where: { existingOwner in
                        existingOwner.id == newOwner.id
                        }
                    ) {
                        return HTTPStatus.conflict
                    }
                } else  {
                    do {
                        try await newOwner.create(on: database)
                        return HTTPStatus.created
                    } catch {
                        let status = HTTPStatus.custom(code: 911, reasonPhrase: error.localizedDescription)
                        return status
                    }
                }
            }
            return HTTPStatus.conflict
        
        
    }

    try app.register(collection: CheckinController())
}
