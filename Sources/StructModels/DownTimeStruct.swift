import Foundation

public struct DownTime: Codable, Identifiable{

    public let id: UUID?
    public var startTime_DaySec: TimeInterval?
    public var endTime_DaySec: TimeInterval?
    public var isOn: Bool = true
    public var devices: [String]?

}