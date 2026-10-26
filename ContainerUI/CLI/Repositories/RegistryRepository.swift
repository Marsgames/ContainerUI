import Foundation
import Security
import OSLog

final class RegistryRepository: IRegistryRepository
{
    private let cli: CLIClient
    private let log = Logger(subsystem: "ContainerUI", category: "RegistryRepository")

    private static let keychainService = "ContainerUI.registries"

    init(cli: CLIClient) { self.cli = cli }

    func listAll() -> [Registry]
    {
        storedRegistries()
    }

    func login(server: String, username: String, password: String) async throws
    {
        try await cli.run(
            ["registry", "login", "--username", username, "--password-stdin", server],
            stdin: password
        )
        saveToKeychain(server: server, username: username, password: password)
    }

    func logout(server: String) async throws
    {
        try await cli.run(["registry", "logout", server])
        deleteFromKeychain(server: server)
    }
}

// MARK: - Keychain

private extension RegistryRepository
{
    func storedRegistries() -> [Registry]
    {
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrService as String:      Self.keychainService,
            kSecMatchLimit as String:       kSecMatchLimitAll,
            kSecReturnAttributes as String: true
        ]

        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let items = result as? [[String: Any]]
        else { return [] }

        return items.compactMap { item -> Registry? in
            guard let server   = item[kSecAttrAccount as String] as? String,
                  let username = item[kSecAttrLabel as String]   as? String
            else { return nil }
            return Registry(server: server, username: username)
        }
    }

    func saveToKeychain(server: String, username: String, password: String)
    {
        guard let passwordData = password.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: Self.keychainService,
            kSecAttrAccount as String: server,
            kSecAttrLabel as String:   username,
            kSecValueData as String:   passwordData
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess { log.error("Keychain save failed for \(server): \(status)") }
    }

    func deleteFromKeychain(server: String)
    {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String: Self.keychainService,
            kSecAttrAccount as String: server
        ]
        SecItemDelete(query as CFDictionary)
    }
}
