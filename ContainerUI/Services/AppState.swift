import SwiftUI
import Observation
import OSLog

enum StartupPhase: Equatable
{
    case loading(message: String, progress: Double)
    case missingComponents
    case installingComponents
    case ready
    case failed(message: String)
}

@Observable
final class AppState
{
    private static let log = Logger(subsystem: "ContainerUI", category: "AppState")

    var phase: StartupPhase = .loading(message: "Checking container system…", progress: 0)

    var runningContainerCount: Int = 0

    let cli: CLIClient
    let containers: ContainerRepository
    let images: ImageRepository

    init()
    {
        let cli = CLIClient()
        self.cli = cli
        self.containers = ContainerRepository(cli: cli)
        self.images = ImageRepository(cli: cli)
    }

    func bootstrap() async
    {
        guard cli.isExecutableAvailable else
        {
            await set(.missingComponents)
            return
        }

        await set(.loading(message: "Connecting to container runtime…", progress: 0.4))

        let isHealthy = await checkHealth()

        if isHealthy
        {
            await set(.loading(message: "Ready", progress: 1))
            try? await Task.sleep(for: .milliseconds(300))
            await set(.ready)
        }
        else
        {
            await set(.missingComponents)
        }
    }

    func installComponents() async
    {
        await set(.installingComponents)
        await set(.loading(message: "Starting container services…", progress: 0.3))

        do
        {
            try await cli.run(command: CLI.SystemCommand.start)
            await set(.loading(message: "Verifying…", progress: 0.8))
            try? await Task.sleep(for: .seconds(1))

            let isHealthy = await checkHealth()

            if isHealthy
            {
                await set(.loading(message: "Ready", progress: 1))
                try? await Task.sleep(for: .milliseconds(300))
                await set(.ready)
            }
            else
            {
                await set(.failed(message: "Runtime started but is not responding."))
            }
        }
        catch
        {
            await set(.failed(message: Errors.CLIMapper.map(error).userMessage))
        }
    }

    func quit()
    {
        NSApplication.shared.terminate(nil)
    }
}

// MARK: - Private helpers

private extension AppState
{
    func checkHealth() async -> Bool
    {
        do
        {
            let _: String = try await cli.run(command: CLI.SystemCommand.healthCheck)
            return true
        }
        catch
        {
            return false
        }
    }

    @MainActor
    func set(_ newPhase: StartupPhase)
    {
        phase = newPhase
    }
}
