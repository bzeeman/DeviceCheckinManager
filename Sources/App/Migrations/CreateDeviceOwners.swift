import Fluent

struct CreateDeviceOwners: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("deviceowner")
            .id()
            .field("firstName", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("deviceowner").delete()
    }
}
