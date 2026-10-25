import Foundation

/// Describes a command to run against the container CLI.
protocol ICLICommand
{
    /// Arguments passed to the executable, not including the executable path itself.
    var arguments: [String] { get }

    /// Human-readable label used for logging.
    var name: String { get }
}
