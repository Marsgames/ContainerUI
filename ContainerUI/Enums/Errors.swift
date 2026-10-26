import Foundation

enum Errors
{
    enum CLI: Error, LocalizedError
    {
        case executableNotFound
        case runtimeNotRunning
        case commandFailed(exitCode: Int32, stderr: String)
        case decodingFailed(Error)
        case unknown(Error)

        var userMessage: String
        {
            switch self
            {
                case .executableNotFound:
                    return "The container CLI was not found. Make sure the container system is installed."
                case .runtimeNotRunning:
                    return "The container runtime is not running."
                case .commandFailed(_, let stderr):
                    return stderr.isEmpty ? "The command failed with no output." : stderr
                case .decodingFailed:
                    return "Received data in an unexpected format."
                case .unknown(let error):
                    return error.localizedDescription
            }
        }

        var debugMessage: String
        {
            switch self
            {
                case .executableNotFound:
                    return "Executable not found at \(CLIClient.executablePath)"
                case .runtimeNotRunning:
                    return "XPC connection error — container daemon not started"
                case .commandFailed(let exitCode, let stderr):
                    return "Exit \(exitCode): \(stderr)"
                case .decodingFailed(let error):
                    return "Decoding failed: \(error)"
                case .unknown(let error):
                    return "Unknown: \(error)"
            }
        }

        var errorDescription: String? { userMessage }
    }

    enum CLIMapper
    {
        static func map(_ error: Error) -> Errors.CLI
        {
            if let cliError = error as? Errors.CLI { return cliError }
            return .unknown(error)
        }
    }
}
