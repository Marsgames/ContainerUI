import Foundation

extension CLI
{
    enum SystemCommand: ICLICommand
    {
        case start
        case healthCheck

        var arguments: [String]
        {
            switch self
            {
                case .start:
                    return ["system", "start"]
                case .healthCheck:
                    return ["list", "--format", "json"]
            }
        }

        var name: String
        {
            switch self
            {
                case .start:        return "container system start"
                case .healthCheck:  return "container list (health check)"
            }
        }
    }
}
