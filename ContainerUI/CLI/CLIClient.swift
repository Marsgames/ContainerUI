import Foundation
import OSLog

struct CLIClient: ICLIClient
{
    static let executablePath = "/usr/local/bin/container"

    private static let log = Logger(subsystem: "ContainerUI", category: "CLIClient")
    private let log: Logger = { CLIClient.log }()

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder())
    {
        self.decoder = decoder
    }

    var isExecutableAvailable: Bool
    {
        FileManager.default.fileExists(atPath: Self.executablePath)
    }
}

// MARK: - ICLIClient

extension CLIClient
{
    func run(command: any ICLICommand) async throws -> String
    {
        guard isExecutableAvailable else { throw Errors.CLI.executableNotFound }

        log.debug("→ \(command.name): \(command.arguments.joined(separator: " "))")

        return try await withCheckedThrowingContinuation
        { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: Self.executablePath)
            process.arguments = command.arguments

            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()
            process.standardOutput = stdoutPipe
            process.standardError = stderrPipe

            do { try process.run() }
            catch
            {
                log.error("✗ \(command.name) process launch failed: \(error)")
                continuation.resume(throwing: Errors.CLI.unknown(error))
                return
            }

            process.waitUntilExit()

            let stdout = String(data: stdoutPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let stderr = String(data: stderrPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let exitCode = process.terminationStatus

            guard exitCode == 0 else
            {
                let mapped = mapFailure(exitCode: exitCode, stderr: stderr)
                log.error("✗ \(command.name) failed [\(exitCode)]: \(stderr)")
                continuation.resume(throwing: mapped)
                return
            }

            log.debug("✓ \(command.name)")
            continuation.resume(returning: stdout)
        }
    }

    func run<T: Decodable>(command: any ICLICommand) async throws -> T
    {
        let output: String = try await run(command: command)

        do
        {
            return try decoder.decode(T.self, from: Data(output.utf8))
        }
        catch let decodingError
        {
            log.error("✗ \(command.name) decoding failed: \(decodingError)")
            throw Errors.CLI.decodingFailed(decodingError)
        }
    }
}

// MARK: - Private helpers

private extension CLIClient
{
    func mapFailure(exitCode: Int32, stderr: String) -> Errors.CLI
    {
        let isXPCFailure = stderr.contains("XPC connection error") || stderr.contains("Connection invalid")
        if isXPCFailure { return .runtimeNotRunning }
        return .commandFailed(exitCode: exitCode, stderr: stderr)
    }
}
