import SwiftUI

@Observable @MainActor
final class ContainersViewModel
{
    var containers: [Container] = []
    var isLoading = false
    var error: String?
    var pendingActions: Set<String> = []
    var containerToDelete: Container?
    var selectedContainer: Container?

    private let repository: any IContainerRepository

    init(repository: any IContainerRepository)
    {
        self.repository = repository
    }

    func refresh() async
    {
        isLoading = true
        error = nil
        do
        {
            containers = try await repository.listAll()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
        isLoading = false
    }

    func start(_ container: Container) async
    {
        await performAction(on: container)
        {
            try await self.repository.start(containerID: container.id)
        }

        if let updated = containers.first(where: { $0.id == container.id }), !updated.status.isRunning
        {
            error = "'\(container.name)' started but exited immediately. The init process may need a TTY or a long-running command."
        }
    }

    func stop(_ container: Container) async
    {
        await performAction(on: container)
        {
            try await self.repository.stop(containerID: container.id)
        }
    }

    func restart(_ container: Container) async
    {
        await performAction(on: container)
        {
            try await self.repository.restart(containerID: container.id)
        }
    }

    func confirmDelete(_ container: Container)
    {
        containerToDelete = container
    }

    func delete(_ container: Container) async
    {
        await performAction(on: container)
        {
            try await self.repository.delete(containerID: container.id)
        }
    }
}

// MARK: - Private helpers

private extension ContainersViewModel
{
    func performAction(on container: Container, action: () async throws -> Void) async
    {
        pendingActions.insert(container.id)
        defer { pendingActions.remove(container.id) }

        do
        {
            try await action()
            await refresh()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
    }
}

// MARK: - ContainersView

struct ContainersView: View
{
    @State private var vm: ContainersViewModel
    let repository: any IContainerRepository

    init(repository: any IContainerRepository)
    {
        self.repository = repository
        _vm = State(wrappedValue: ContainersViewModel(repository: repository))
    }

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x242424).ignoresSafeArea()

            if vm.isLoading && vm.containers.isEmpty
            {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color(hex: 0x4ADE80))
            }
            else if vm.containers.isEmpty
            {
                emptyState
            }
            else
            {
                containerList
            }
        }
        .task { await vm.refresh() }
        .toolbar
        {
            ToolbarItem(placement: .automatic)
            {
                HelpToolbarButton(
                    title: String(localized: "help.containers.title"),
                    helpText: String(localized: "help.containers.body")
                )
            }
            ToolbarItem(placement: .automatic)
            {
                Button { Task { await vm.refresh() } } label:
                {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 4)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Refresh containers")
            }
        }
        .sheet(item: $vm.selectedContainer)
        { container in
            ContainerDetailView(containerID: container.id, containerName: container.name, repository: repository)
        }
        .confirmationDialog(
            "Delete \"\(vm.containerToDelete?.name ?? "")\"?",
            isPresented: Binding(get: { vm.containerToDelete != nil }, set: { if !$0 { vm.containerToDelete = nil } }),
            titleVisibility: .visible
        )
        {
            Button("Delete", role: .destructive)
            {
                if let container = vm.containerToDelete
                {
                    Task { await vm.delete(container) }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove the container.")
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
            Image(systemName: "shippingbox")
                .font(.system(size: 40, weight: .thin))
                .foregroundColor(.white.opacity(0.3))
            Text("No containers")
                .foregroundColor(.white.opacity(0.4))
                .font(.system(size: 15))
        }
    }

    private var containerList: some View
    {
        ScrollView
        {
            LazyVStack(spacing: 1)
            {
                ForEach(vm.containers)
                { container in
                    ContainerRow(
                        container: container,
                        isPending: vm.pendingActions.contains(container.id)
                    )
                    { action in
                        Task
                        {
                            switch action
                            {
                                case .start:   await vm.start(container)
                                case .stop:    await vm.stop(container)
                                case .restart: await vm.restart(container)
                                case .delete:  vm.confirmDelete(container)
                                case .inspect: vm.selectedContainer = container
                            }
                        }
                    }
                }
            }
            .padding(.top, 1)
        }
    }
}

// MARK: - ContainerRow

enum ContainerAction { case start, stop, restart, delete, inspect }

struct ContainerRow: View
{
    let container: Container
    let isPending: Bool
    let onAction: (ContainerAction) -> Void

    var body: some View
    {
        HStack(spacing: 14)
        {
            statusIndicator

            VStack(alignment: .leading, spacing: 2)
            {
                Text(container.name)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .medium))
                Text(container.image)
                    .foregroundColor(.white.opacity(0.45))
                    .font(.system(size: 11))
            }

            Spacer()

            statusBadge

            actions
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: 0x2A2A2A))
        .opacity(isPending ? 0.6 : 1)
        .animation(.easeInOut(duration: 0.15), value: isPending)
        .onTapGesture { onAction(.inspect) }
    }

    private var statusIndicator: some View
    {
        ZStack
        {
            if isPending
            {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.5)
                    .tint(.white.opacity(0.6))
                    .frame(width: 8, height: 8)
            }
            else
            {
                Circle()
                    .fill(container.status.isRunning ? Color(hex: 0x4ADE80) : Color(hex: 0x555555))
                    .frame(width: 8, height: 8)
            }
        }
        .frame(width: 8, height: 8)
        .accessibilityLabel(container.status.isRunning ? "Running" : "Stopped")
        .accessibilityHidden(isPending)
    }

    private var statusBadge: some View
    {
        let label = isPending ? "…" : container.status.rawValue
        let isGreen = container.status.isRunning && !isPending

        return Text(label)
            .foregroundColor(isGreen ? Color(hex: 0x4ADE80) : Color.white.opacity(0.4))
            .font(.system(size: 11, weight: .medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(isGreen
                          ? Color(hex: 0x4ADE80).opacity(0.12)
                          : Color.white.opacity(0.06))
            )
    }

    @ViewBuilder
    private var actions: some View
    {
        HStack(spacing: 4)
        {
            if isPending
            {
                Color.clear.frame(width: 28, height: 28)
            }
            else
            {
                if container.status.isRunning
                {
                    actionButton("stop.fill", color: Color(hex: 0xFF6B35), label: "Stop \(container.name)") { onAction(.stop) }
                    actionButton("arrow.clockwise", color: .white.opacity(0.5), label: "Restart \(container.name)") { onAction(.restart) }
                }
                else
                {
                    actionButton("play.fill", color: Color(hex: 0x4ADE80), label: "Start \(container.name)") { onAction(.start) }
                }
                actionButton("trash", color: .white.opacity(0.35), label: "Delete \(container.name)") { onAction(.delete) }
            }
        }
    }

    private func actionButton(_ icon: String, color: Color, label: String, action: @escaping () -> Void) -> some View
    {
        Button(action: action)
        {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(Color.white.opacity(0.05))
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}
