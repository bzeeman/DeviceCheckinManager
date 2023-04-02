import Fluent
import Vapor
import DeviceCheckinWatcher

struct CheckinController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        Task{
            await DMesgWatcher.runner.run()
        }

        let deviceOwners = routes.grouped("deviceowner")
        deviceOwners.get(use: index)
        deviceOwners.post(use: create)
        deviceOwners.group(":deviceownerID") { owner in
            owner.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [DeviceOwner] {
        try await DeviceOwner.query(on: req.db).all()
    }

    func create(req: Request) async throws -> DeviceOwner {
        let owner = try req.content.decode(DeviceOwner.self)
        try await owner.save(on: req.db)
        return owner
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let owner = try await DeviceOwner.find(req.parameters.get("deviceownerID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await owner.delete(on: req.db)
        return .noContent
    }
}
