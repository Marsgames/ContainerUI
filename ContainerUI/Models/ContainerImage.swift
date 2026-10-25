import Foundation

struct ContainerImage: Identifiable, Codable, Hashable {
    var id: String { "\(name):\(tag)" }
    let name: String
    let tag: String
    let size: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case name
        case tag
        case size
        case createdAt = "created"
    }
}
