import Foundation

extension CLI
{
    enum ImageCommand: ICLICommand
    {
        case listAll

        var arguments: [String]
        {
            switch self
            {
                case .listAll:
                    return ["images", "list", "--format", "json"]
            }
        }

        var name: String
        {
            switch self
            {
                case .listAll: return "container images list"
            }
        }
    }
}
