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
}
