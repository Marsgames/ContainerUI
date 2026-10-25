import SwiftUI

@Observable @MainActor
final class RegistriesViewModel
{
    var registries: [Registry] = []
    var error: String?
    var showAddSheet = false
    var isLoggingOut = false

    private let repository: any IRegistryRepository

    init(repository: any IRegistryRepository)
    {
        self.repository = repository
    }

    func load()
    {
        registries = repository.listAll()
    }

    func login(server: String, username: String, password: String) async
    {
        error = nil
        do
        {
            try await repository.login(server: server, username: username, password: password)
            load()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
    }

    func logout(registry: Registry) async
    {
        error = nil
        do
        {
            try await repository.logout(server: registry.server)
            load()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
    }
}

// MARK: - RegistriesView

struct RegistriesView: View
{
    @State private var vm: RegistriesViewModel

    init(repository: any IRegistryRepository)
    {
        _vm = State(wrappedValue: RegistriesViewModel(repository: repository))
    }

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x242424).ignoresSafeArea()

            if vm.registries.isEmpty
            {
                emptyState
            }
            else
            {
                registryList
            }
        }
        .onAppear { vm.load() }
        .toolbar
        {
            ToolbarItem(placement: .automatic)
            {
                HelpToolbarButton(
                    title: String(localized: "help.registries.title"),
                    helpText: String(localized: "help.registries.body")
                )
            }
            ToolbarItem(placement: .automatic)
            {
                Button { vm.showAddSheet = true } label:
                {
                    Image(systemName: "plus")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 4)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add registry")
            }
        }
        .sheet(isPresented: $vm.showAddSheet)
        {
            AddRegistrySheet
            { server, username, password in
                vm.showAddSheet = false
                Task { await vm.login(server: server, username: username, password: password) }
            } onCancel: {
                vm.showAddSheet = false
            }
        }
        .if(vm.error != nil)
        { view in
            view.overlay(alignment: .bottom)
            {
                ErrorBanner(message: vm.error!) { vm.error = nil }
                    .padding()
            }
        }
    }

    private var emptyState: some View
    {
        VStack(spacing: 12)
        {
            Image(systemName: "building.2")
                .font(.system(size: 40, weight: .thin))
                .foregroundColor(.white.opacity(0.3))
            Text("No registries")
                .foregroundColor(.white.opacity(0.4))
                .font(.system(size: 15))
            Button { vm.showAddSheet = true } label:
            {
                Text("Add a registry")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: 0x4ADE80))
            }
            .buttonStyle(.plain)
        }
    }

    private var registryList: some View
    {
        ScrollView
        {
            LazyVStack(spacing: 1)
            {
                ForEach(vm.registries)
                { registry in
                    RegistryRow(registry: registry)
                    {
                        Task { await vm.logout(registry: registry) }
                    }
                }
            }
            .padding(.top, 1)
        }
    }
}

// MARK: - RegistryRow

struct RegistryRow: View
{
    let registry: Registry
    let onLogout: () -> Void

    var body: some View
    {
        HStack(spacing: 14)
        {
            Image(systemName: "building.2")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2)
            {
                Text(registry.server)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .medium))
                Text(registry.username)
                    .foregroundColor(.white.opacity(0.45))
                    .font(.system(size: 11))
            }

            Spacer()

            Button("Logout", action: onLogout)
                .buttonStyle(.plain)
                .foregroundColor(Color(hex: 0xFF6B35))
                .font(.system(size: 12))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(hex: 0xFF6B35).opacity(0.08))
                .cornerRadius(6)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: 0x2A2A2A))
    }
}

// MARK: - AddRegistrySheet

struct AddRegistrySheet: View
{
    let onAdd: (String, String, String) -> Void
    let onCancel: () -> Void

    @State private var server = ""
    @State private var username = ""
    @State private var password = ""

    private var isValid: Bool
    {
        !server.trimmingCharacters(in: .whitespaces).isEmpty &&
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20)
            {
                Text("Add registry")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))

                labeledField("Server", placeholder: "e.g. ghcr.io", text: $server)
                labeledField("Username", placeholder: "your username", text: $username)
                labeledSecureField("Password / token", placeholder: "password or access token", text: $password)

                HStack
                {
                    Spacer()
                    Button("Cancel", action: onCancel)
                        .buttonStyle(.plain)
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 13))

                    Button("Login")
                    {
                        onAdd(
                            server.trimmingCharacters(in: .whitespaces),
                            username.trimmingCharacters(in: .whitespaces),
                            password
                        )
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(isValid ? Color(hex: 0x4ADE80) : .white.opacity(0.3))
                    .font(.system(size: 13, weight: .semibold))
                    .disabled(!isValid)
                }
            }
            .padding(24)
        }
        .frame(width: 440, height: 300)
    }

    private func labeledField(_ label: String, placeholder: String, text: Binding<String>) -> some View
    {
        VStack(alignment: .leading, spacing: 5)
        {
            Text(label)
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 11))
            TextField(placeholder, text: text)
                .textFieldStyle(.plain)
                .foregroundColor(.white)
                .font(.system(size: 13))
                .padding(10)
                .background(Color(hex: 0x2A2A2A))
                .cornerRadius(8)
        }
    }

    private func labeledSecureField(_ label: String, placeholder: String, text: Binding<String>) -> some View
    {
        VStack(alignment: .leading, spacing: 5)
        {
            Text(label)
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 11))
            SecureField(placeholder, text: text)
                .textFieldStyle(.plain)
                .foregroundColor(.white)
                .font(.system(size: 13))
                .padding(10)
                .background(Color(hex: 0x2A2A2A))
                .cornerRadius(8)
        }
    }
}
