import Foundation

struct Container: Identifiable, Decodable, Hashable
{
    var id: String { configuration.id }
    var name: String { configuration.hostname }
    var image: String { configuration.image.reference }
    let status: ContainerStatus
    let configuration: Configuration

    enum CodingKeys: String, CodingKey
    {
        case status
        case configuration
    }

    // MARK: - Nested types

    struct Configuration: Decodable, Hashable
    {
        let id: String
        let hostname: String
        let image: ImageRef

        struct ImageRef: Decodable, Hashable
        {
            let reference: String

            enum CodingKeys: String, CodingKey { case reference }
        }
    }
}

enum ContainerStatus: String, Decodable, Hashable
{
    case running
    case stopped
    case created
    case exited
    case unknown

    init(from decoder: Decoder) throws
    {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = ContainerStatus(rawValue: raw.lowercased()) ?? .unknown
    }

    var isRunning: Bool { self == .running }
}
