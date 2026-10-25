import Foundation

protocol IRegistryRepository
{
    func listAll() -> [Registry]
    func login(server: String, username: String, password: String) async throws
    func logout(server: String) async throws
}
