import Foundation

protocol ICLIClient
{
    /// Run a command and return its raw stdout output.
    func run(command: ICLICommand) async throws -> String

    /// Run a command, decode the JSON stdout into `T`, and return it.
    func run<T: Decodable>(command: ICLICommand) async throws -> T
}
