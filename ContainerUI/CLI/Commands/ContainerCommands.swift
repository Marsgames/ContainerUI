import Foundation

extension CLI
{
    enum ContainerCommand: ICLICommand
    {
        case listAll
        case start(containerID: String)
        case stop(containerID: String)
        case delete(containerID: String)
        case inspect(containerID: String)
        case logs(containerID: String)

        var arguments: [String]
        {
            switch self
            {
                case .listAll:
                    return ["list", "--all", "--format", "json"]
                case .start(let containerID):
                    return ["start", containerID]
                case .stop(let containerID):
                    return ["stop", containerID]
                case .delete(let containerID):
                    return ["rm", "--force", containerID]
                case .inspect(let containerID):
                    return ["inspect", containerID]
                case .logs(let containerID):
                    return ["logs", containerID]
            }
        }

        var name: String
        {
            switch self
            {
                case .listAll:                  return "container list"
                case .start(let id):            return "container start \(id)"
                case .stop(let id):             return "container stop \(id)"
                case .delete(let id):           return "container rm \(id)"
                case .inspect(let id):          return "container inspect \(id)"
                case .logs(let id):             return "container logs \(id)"
            }
        }
    }
}
