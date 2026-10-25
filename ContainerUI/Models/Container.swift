import Foundation

struct Container: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let image: String
    let status: ContainerStatus
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case status
        case createdAt = "created"
    }
}

enum ContainerStatus: String, Codable, Hashable {
    case running
    case stopped
    case created
    case exited
    case unknown

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = ContainerStatus(rawValue: raw.lowercased()) ?? .unknown
    }

    var isRunning: Bool { self == .running }
}
