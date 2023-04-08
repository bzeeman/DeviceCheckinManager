import Fluent
import Vapor
import DeviceCheckinWatcher
import Foundation
import DeviceCheckinTypes

extension DeviceOwnerRequest: Content {}

extension DownTimeRequest: Content {}

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
        do {
            if let newOwner = req.body.data {
                let d = Data(buffer: newOwner)
                if let json = DeviceOwnerRequest.fromJSON(data: d) {
                    print(json)
                }
            }
            
            let database = req.db
        } catch {
            print(error)
            return HTTPStatus.custom(code: 911, reasonPhrase: error.localizedDescription)
        }
        
        return HTTPStatus.conflict

    }

    try app.register(collection: CheckinController())
}
