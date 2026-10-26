import Foundation

protocol IContainerRepository
{
    // MARK: - Queries

    func listAll() async throws -> [Container]
    func inspect(containerID: String) async throws -> ContainerDetail
    func logs(containerID: String) async throws -> String

    // MARK: - Actions

    func start(containerID: String) async throws
    func stop(containerID: String) async throws
    func restart(containerID: String) async throws
    func delete(containerID: String) async throws
}
