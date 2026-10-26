import Foundation

struct ContainerDetail: Decodable
{
    let configuration: Configuration
    let networks: [NetworkInfo]
    let status: ContainerStatus

    struct Configuration: Decodable
    {
        let id: String
        let hostname: String
        let image: ImageRef
        let resources: Resources
        let mounts: [Mount]
        let initProcess: InitProcess
        let networks: [String]

        struct ImageRef: Decodable { let reference: String }

        struct Resources: Decodable
        {
            let memoryInBytes: Int
            let cpus: Int

            var memoryFormatted: String
            {
                let gb = Double(memoryInBytes) / 1_073_741_824
                if gb >= 1 { return String(format: "%.1f GB", gb) }
                let mb = memoryInBytes / 1_048_576
                return "\(mb) MB"
            }
        }

        struct Mount: Decodable, Identifiable
        {
            let source: String
            let destination: String
            var id: String { "\(source):\(destination)" }
        }

        struct InitProcess: Decodable
        {
            let executable: String
            let arguments: [String]
            let environment: [String]
            let workingDirectory: String
        }
    }

    struct NetworkInfo: Decodable, Identifiable
    {
        let name: String?
        let address: String?
        var id: String { "\(name ?? ""):\(address ?? "")" }
    }
}
