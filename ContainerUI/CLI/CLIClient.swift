import Foundation
import OSLog

struct CLIClient
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

    // MARK: - Run

    @discardableResult
    func run(_ arguments: [String], stdin: String? = nil) async throws -> String
    {
        guard isExecutableAvailable else { throw Errors.CLI.executableNotFound }

        let label = "container \(arguments.joined(separator: " "))"
        log.debug("→ \(label)")

        return try await withCheckedThrowingContinuation
        { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: Self.executablePath)
            process.arguments = arguments

            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()
            process.standardOutput = stdoutPipe
            process.standardError = stderrPipe

            if let text = stdin
            {
                let stdinPipe = Pipe()
                process.standardInput = stdinPipe
                if let data = text.data(using: .utf8)
                {
                    stdinPipe.fileHandleForWriting.write(data)
                    stdinPipe.fileHandleForWriting.closeFile()
                }
            }

            do {
                try process.run()
            }
            catch
            {
                log.error("✗ \(label) process launch failed: \(error)")
                let nsErr = error as NSError
                if nsErr.domain == NSCocoaErrorDomain && nsErr.code == NSFileNoSuchFileError {
                    continuation.resume(throwing: Errors.CLI.executableNotFound)
                } else {
                    continuation.resume(throwing: Errors.CLI.unknown(error))
                }
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
                log.error("✗ \(label) [\(exitCode)]: \(stderr)")
                continuation.resume(throwing: mapped)
                return
            }

            log.debug("✓ \(label)")
            continuation.resume(returning: stdout)
        }
    }

    func run<T: Decodable>(_ arguments: [String]) async throws -> T
    {
        let output: String = try await run(arguments, stdin: nil)

        do
        {
            return try decoder.decode(T.self, from: Data(output.utf8))
        }
        catch let decodingError
        {
            log.error("✗ container \(arguments.joined(separator: " ")) decoding failed: \(decodingError)")
            throw Errors.CLI.decodingFailed(decodingError)
        }
    }
}

// MARK: - Private

private extension CLIClient
{
    func mapFailure(exitCode: Int32, stderr: String) -> Errors.CLI
    {
        let isXPCFailure = stderr.contains("XPC connection error") || stderr.contains("Connection invalid")
        if isXPCFailure { return .runtimeNotRunning }
        return .commandFailed(exitCode: exitCode, stderr: stderr)
    }
}
