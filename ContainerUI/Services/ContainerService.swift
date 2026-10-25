import Foundation
import SwiftUI

enum ContainerServiceError: LocalizedError {
    case runtimeNotRunning
    case missingCLI
    case commandFailed(String)
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .runtimeNotRunning:   return "The container runtime is not running."
        case .missingCLI:          return "The container CLI was not found at /usr/local/bin/container."
        case .commandFailed(let m): return m
        case .decodingFailed(let m): return "Failed to parse output: \(m)"
        }
    }
}

@MainActor @Observable
final class ContainerService {

    static let cliPath = "/usr/local/bin/container"

    var containers: [Container] = []

    // MARK: - Runtime check

    var isCLIAvailable: Bool {
        FileManager.default.fileExists(atPath: Self.cliPath)
    }

    func startRuntime() async throws {
        try await run([Self.cliPath, "system", "start"])
    }

    func isRuntimeHealthy() async -> Bool {
        guard isCLIAvailable else { return false }
        do {
            _ = try await run([Self.cliPath, "list", "--format", "json"])
            return true
        } catch {
            return false
        }
    }

    // MARK: - Containers

    func listContainers(all: Bool = true) async throws -> [Container] {
        var args = [Self.cliPath, "list", "--format", "json"]
        if all { args.append("--all") }
        let output = try await run(args)
        guard !output.isEmpty else {
            containers = []
            return []
        }
        do {
            let result = try JSONDecoder().decode([Container].self, from: Data(output.utf8))
            containers = result
            return result
        } catch {
            throw ContainerServiceError.decodingFailed(error.localizedDescription)
        }
    }

    func startContainer(_ id: String) async throws {
        try await run([Self.cliPath, "start", id])
    }

    func stopContainer(_ id: String) async throws {
        try await run([Self.cliPath, "stop", id])
    }

    func restartContainer(_ id: String) async throws {
        try await run([Self.cliPath, "stop", id])
        try await run([Self.cliPath, "start", id])
    }

    func deleteContainer(_ id: String) async throws {
        try await run([Self.cliPath, "rm", id])
    }

    // MARK: - Images

    func listImages() async throws -> [ContainerImage] {
        let output = try await run([Self.cliPath, "images", "list", "--format", "json"])
        guard !output.isEmpty else { return [] }
        do {
            return try JSONDecoder().decode([ContainerImage].self, from: Data(output.utf8))
        } catch {
            throw ContainerServiceError.decodingFailed(error.localizedDescription)
        }
    }

    // MARK: - Private

    @discardableResult
    private func run(_ arguments: [String]) async throws -> String {
        guard isCLIAvailable else { throw ContainerServiceError.missingCLI }

        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: arguments[0])
            process.arguments = Array(arguments.dropFirst())

            let stdout = Pipe()
            let stderr = Pipe()
            process.standardOutput = stdout
            process.standardError = stderr

            do {
                try process.run()
            } catch {
                continuation.resume(throwing: ContainerServiceError.commandFailed(error.localizedDescription))
                return
            }

            process.waitUntilExit()

            let out = String(data: stdout.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
            let err = String(data: stderr.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""

            if process.terminationStatus != 0 {
                let message = err.isEmpty ? out : err
                if message.contains("XPC connection error") || message.contains("Connection invalid") {
                    continuation.resume(throwing: ContainerServiceError.runtimeNotRunning)
                } else {
                    continuation.resume(throwing: ContainerServiceError.commandFailed(message.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            } else {
                continuation.resume(returning: out.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
}
