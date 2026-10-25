import Foundation

protocol IImageRepository
{
    func listAll() async throws -> [ContainerImage]
}
