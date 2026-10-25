import Foundation

final class ContainerRepository: IContainerRepository
{
    private let cli: CLIClient

    init(cli: CLIClient)
    {
        self.cli = cli
    }

    // MARK: - IContainerRepository

    func listAll() async throws -> [Container]
    {
        return try await cli.run(command: CLI.ContainerCommand.listAll)
    }

    func start(containerID: String) async throws
    {
        try await cli.run(command: CLI.ContainerCommand.start(containerID: containerID))
    }

    func stop(containerID: String) async throws
    {
        try await cli.run(command: CLI.ContainerCommand.stop(containerID: containerID))
    }

    func restart(containerID: String) async throws
    {
        try await stop(containerID: containerID)
        try await start(containerID: containerID)
    }

    func delete(containerID: String) async throws
    {
        try await cli.run(command: CLI.ContainerCommand.delete(containerID: containerID))
    }
}
