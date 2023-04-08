import Fluent
import Vapor
import DeviceCheckinWatcher

public final class DeviceOwner: Model, Content {
    public static var schema: String = "deviceowner"

    public required init() {
    }

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "firstName")
    public var firstName: String?

    @Field(key: "lastName")
    public var lastName: String?

    @Field(key: "birthday")
    public var birthday: Date?

    @Field(key: "devices")
    public var devices: [String]?

    @Field(key: "downTimes")
    public var downTimes: [DownTime]?

    public init(firstName: String, 
        lastName: String? = nil, 
        birthday: Date? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
}

public extension DeviceOwner {
    func add(device: IdentifiableUSBDevice) -> Bool {
        let deviceId = device.id
        if !(devices?.contains(deviceId) == true) {
            self.devices?.append(deviceId)
            return true
        }
        return false
    }

    func add(downTime: DownTime) -> Bool {
        return false
    }

    var age: Int? {
        let cal = Calendar(identifier: .gregorian)
        if let birthday {
            cal.dateComponents( [.year], from: birthday)
        }

        return nil
    }
}

public struct DownTime: Content{

    public let id: UUID?
    public var startTime_DaySec: TimeInterval?
    public var endTime_DaySec: TimeInterval?
    public var isOn: Bool = true
    public var devices: [String]?

}
