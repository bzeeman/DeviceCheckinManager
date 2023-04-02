import Foundation

public struct DeviceOwner: Codable {

    public private(set)var id: UUID?
    public var firstName: String?
    public var lastName: String?
    public var birthday: Date?
    public var devices: [String]?
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

    mutating func add(downTime: DownTime) -> Bool {
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