import Foundation

final class ImageRepository: IImageRepository
{
    private let cli: CLIClient

    init(cli: CLIClient) { self.cli = cli }

    func listAll() async throws -> [ContainerImage]
    {
        try await cli.run(["images", "list", "--format", "json"])
    }

    func pull(reference: String) async throws
    {
        try await cli.run(["images", "pull", reference])
    }

    func delete(reference: String) async throws
    {
        try await cli.run(["images", "delete", reference])
    }
}
