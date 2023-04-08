import Fluent

struct CreateDeviceOwners: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("deviceowner")
            .id()
            .field("firstName", .string, .required)
            .field("lastName", .string)
            .field("birthday", .date)
            .field("devices", .array(of: .string))
            .field("downTimes", .array(of: .custom(DownTime.self)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("deviceowner").delete()
    }
}
