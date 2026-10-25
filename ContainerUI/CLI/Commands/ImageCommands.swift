import Foundation

extension CLI
{
    enum ImageCommand: ICLICommand
    {
        case listAll
        case pull(reference: String)
        case delete(reference: String)

        var arguments: [String]
        {
            switch self
            {
                case .listAll:
                    return ["images", "list", "--format", "json"]
                case .pull(let reference):
                    return ["images", "pull", reference]
                case .delete(let reference):
                    return ["images", "rm", reference]
            }
        }

        var name: String
        {
            switch self
            {
                case .listAll:                  return "container images list"
                case .pull(let ref):            return "container images pull \(ref)"
                case .delete(let ref):          return "container images rm \(ref)"
            }
        }
    }
}
