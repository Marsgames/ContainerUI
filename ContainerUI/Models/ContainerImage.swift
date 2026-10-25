import Foundation

struct ContainerImage: Identifiable, Decodable, Hashable
{
    /// Full OCI reference, e.g. "docker.io/library/debian:latest"
    let reference: String

    var id: String { reference }

    /// Repository portion — everything before the last colon.
    var repository: String
    {
        guard let colonIndex = reference.lastIndex(of: ":") else { return reference }
        return String(reference[reference.startIndex ..< colonIndex])
    }

    /// Tag portion — everything after the last colon, or "latest" if absent.
    var tag: String
    {
        guard let colonIndex = reference.lastIndex(of: ":") else { return "latest" }
        let afterColon = reference.index(after: colonIndex)
        return String(reference[afterColon...])
    }

    enum CodingKeys: String, CodingKey
    {
        case reference
    }
}
