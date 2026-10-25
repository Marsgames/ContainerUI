import Foundation

struct Registry: Identifiable, Hashable, Codable
{
    let server: String
    let username: String

    var id: String { server }
}
