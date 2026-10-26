import Foundation

final class ContainerRepository: IContainerRepository
{
    private let cli: CLIClient

    init(cli: CLIClient) { self.cli = cli }

    func listAll() async throws -> [Container]
    {
        try await cli.run(["list", "--all", "--format", "json"])
    }

    func inspect(containerID: String) async throws -> ContainerDetail
    {
        let items: [ContainerDetail] = try await cli.run(["inspect", containerID])
        guard let detail = items.first else {
            throw Errors.CLI.commandFailed(exitCode: 1, stderr: "No data for \(containerID)")
        }
        return detail
    }

    func logs(containerID: String) async throws -> String
    {
        try await cli.run(["logs", containerID])
    }

    func start(containerID: String) async throws
    {
        try await cli.run(["start", containerID])
    }

    func stop(containerID: String) async throws
    {
        _ = try await cli.run(["stop", containerID])
    }

    func restart(containerID: String) async throws
    {
        try await stop(containerID: containerID)
        try await start(containerID: containerID)
    }

    func delete(containerID: String) async throws
    {
        try await cli.run(["rm", "--force", containerID])
    }
}
