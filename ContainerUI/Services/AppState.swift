import SwiftUI
import Observation
import OSLog

enum MissingComponentsReason: Equatable
{
    /// The `container` CLI was not found on disk — the whole system needs to be installed.
    case cliNotFound
    /// The CLI is present but the XPC daemon is not running — `container system start` can fix it.
    case runtimeNotRunning
}

enum StartupPhase: Equatable
{
    case loading(message: String, progress: Double)
    case missingComponents(reason: MissingComponentsReason)
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
    let registries: RegistryRepository

    init()
    {
        let cli = CLIClient()
        self.cli = cli
        self.containers = ContainerRepository(cli: cli)
        self.images = ImageRepository(cli: cli)
        self.registries = RegistryRepository(cli: cli)
    }

    func bootstrap() async
    {
        guard cli.isExecutableAvailable else
        {
            set(.missingComponents(reason: .cliNotFound))
            return
        }

        await set(.loading(message: "Connecting to container runtime…", progress: 0.4))

        if let reason = await checkHealth()
        {
            set(.missingComponents(reason: reason))
        }
        else
        {
            set(.loading(message: "Ready", progress: 1))
            try? await Task.sleep(for: .milliseconds(300))
            set(.ready)
        }
    }

    func installComponents() async
    {
        set(.installingComponents)
        await set(.loading(message: "Starting container services…", progress: 0.3))

        do
        {
            try await cli.run(["system", "start"])
            await set(.loading(message: "Verifying…", progress: 0.8))
            try? await Task.sleep(for: .seconds(1))

            if let reason = await checkHealth()
            {
                set(.missingComponents(reason: reason))
            }
            else
            {
                await set(.loading(message: "Ready", progress: 1))
                try? await Task.sleep(for: .milliseconds(300))
                set(.ready)
            }
        }
        catch
        {
            set(.failed(message: Errors.CLIMapper.map(error).userMessage))
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
    func checkHealth() async -> MissingComponentsReason?
    {
        do
        {
            try await cli.run(["list", "--format", "json"])
            return nil
        }
        catch Errors.CLI.executableNotFound
        {
            return .cliNotFound
        }
        catch
        {
            return .runtimeNotRunning
        }
    }

    @MainActor
    func set(_ newPhase: StartupPhase)
    {
        phase = newPhase
    }
}
