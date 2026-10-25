import SwiftUI
import Observation

enum StartupPhase: Equatable {
    case loading(message: String, progress: Double)
    case missingComponents
    case installingComponents
    case ready
    case failed(String)
}

@Observable
final class AppState {
    var phase: StartupPhase = .loading(message: "Checking container system…", progress: 0)

    let service = ContainerService()

    func bootstrap() async {
        guard service.isCLIAvailable else {
            await MainActor.run { phase = .missingComponents }
            return
        }

        await set(.loading(message: "Connecting to container runtime…", progress: 0.4))
        let healthy = await service.isRuntimeHealthy()

        if healthy {
            await set(.loading(message: "Ready", progress: 1))
            try? await Task.sleep(for: .milliseconds(300))
            await set(.ready)
        } else {
            await set(.missingComponents)
        }
    }

    func installComponents() async {
        await set(.installingComponents)
        await set(.loading(message: "Starting container services…", progress: 0.3))
        do {
            try await service.startRuntime()
            await set(.loading(message: "Verifying…", progress: 0.8))
            try? await Task.sleep(for: .seconds(1))
            let healthy = await service.isRuntimeHealthy()
            if healthy {
                await set(.loading(message: "Ready", progress: 1))
                try? await Task.sleep(for: .milliseconds(300))
                await set(.ready)
            } else {
                await set(.failed("Runtime started but is not responding."))
            }
        } catch {
            await set(.failed(error.localizedDescription))
        }
    }

    func quit() {
        NSApplication.shared.terminate(nil)
    }

    @MainActor
    private func set(_ newPhase: StartupPhase) {
        phase = newPhase
    }
}
