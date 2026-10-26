import Foundation

// MARK: - Mock data

enum MockData
{
    static let containers: [Container] = [
        .make(id: "abc123", name: "web-server", image: "docker.io/library/nginx:latest", status: .running),
        .make(id: "def456", name: "postgres-db", image: "docker.io/library/postgres:16", status: .stopped),
        .make(id: "ghi789", name: "redis-cache", image: "docker.io/library/redis:alpine", status: .running),
    ]

    static let images: [ContainerImage] = [
        ContainerImage(reference: "docker.io/library/nginx:latest"),
        ContainerImage(reference: "docker.io/library/postgres:16"),
        ContainerImage(reference: "docker.io/library/redis:alpine"),
        ContainerImage(reference: "ghcr.io/myorg/myapp:v1.2.0"),
    ]

    static let registries: [Registry] = [
        Registry(server: "ghcr.io", username: "raphdaumas"),
        Registry(server: "registry.hub.docker.com", username: "raphdaumas"),
    ]

    static let containerDetail: ContainerDetail = .make(for: containers[0])
}

// MARK: - Container factory

private extension Container
{
    static func make(id: String, name: String, image: String, status: ContainerStatus) -> Container
    {
        let json = """
        {
          "status": "\(status.rawValue)",
          "configuration": {
            "id": "\(id)",
            "hostname": "\(name)",
            "image": { "reference": "\(image)" }
          }
        }
        """
        return try! JSONDecoder().decode(Container.self, from: Data(json.utf8))
    }
}

// MARK: - ContainerDetail factory

private extension ContainerDetail
{
    static func make(for container: Container) -> ContainerDetail
    {
        let json = """
        {
          "status": "\(container.status.rawValue)",
          "networks": [{ "name": "bridge", "address": "192.168.64.5" }],
          "configuration": {
            "id": "\(container.id)",
            "hostname": "\(container.name)",
            "image": { "reference": "\(container.image)" },
            "resources": { "memoryInBytes": 2147483648, "cpus": 2 },
            "mounts": [
              { "source": "/Users/dev/app", "destination": "/app" }
            ],
            "networks": ["bridge"],
            "initProcess": {
              "executable": "/bin/sh",
              "arguments": [],
              "environment": ["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"],
              "workingDirectory": "/"
            }
          }
        }
        """
        return try! JSONDecoder().decode(ContainerDetail.self, from: Data(json.utf8))
    }
}

// MARK: - Mock repositories

final class MockContainerRepository: IContainerRepository
{
    var containers = MockData.containers
    var shouldFail = false

    func listAll() async throws -> [Container]
    {
        if shouldFail { throw PreviewError.mock }
        return containers
    }

    func inspect(containerID: String) async throws -> ContainerDetail
    {
        guard let c = containers.first(where: { $0.id == containerID }) else { throw PreviewError.mock }
        return ContainerDetail.make(for: c)
    }

    func logs(containerID: String) async throws -> String
    {
        "2024-01-01T00:00:00Z Starting service…\n2024-01-01T00:00:01Z Listening on :8080"
    }

    func start(containerID: String) async throws {}
    func stop(containerID: String) async throws {}
    func restart(containerID: String) async throws {}
    func delete(containerID: String) async throws {}
}

final class MockImageRepository: IImageRepository
{
    var shouldFail = false

    func listAll() async throws -> [ContainerImage]
    {
        if shouldFail { throw PreviewError.mock }
        return MockData.images
    }

    func pull(reference: String) async throws
    {
        try? await Task.sleep(for: .seconds(1))
    }

    func delete(reference: String) async throws {}
}

final class MockRegistryRepository: IRegistryRepository
{
    func listAll() -> [Registry] { MockData.registries }
    func login(server: String, username: String, password: String) async throws {}
    func logout(server: String) async throws {}
}

// MARK: -

private enum PreviewError: Error { case mock }
