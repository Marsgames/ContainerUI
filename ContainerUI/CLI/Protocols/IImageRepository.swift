import Foundation

protocol IImageRepository
{
    func listAll() async throws -> [ContainerImage]
    func pull(reference: String) async throws
    func delete(reference: String) async throws
}
