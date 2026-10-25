import Foundation

final class ImageRepository: IImageRepository
{
    private let cli: CLIClient

    init(cli: CLIClient)
    {
        self.cli = cli
    }

    // MARK: - IImageRepository

    func listAll() async throws -> [ContainerImage]
    {
        return try await cli.run(command: CLI.ImageCommand.listAll)
    }

    func pull(reference: String) async throws
    {
        try await cli.run(command: CLI.ImageCommand.pull(reference: reference))
    }

    func delete(reference: String) async throws
    {
        try await cli.run(command: CLI.ImageCommand.delete(reference: reference))
    }
}
