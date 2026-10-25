import SwiftUI

@Observable @MainActor
final class ContainersViewModel
{
    var containers: [Container] = []
    var isLoading = false
    var error: String?

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
        do
        {
            try await repository.start(containerID: container.id)
            await refresh()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
    }

    func stop(_ container: Container) async
    {
        do
        {
            try await repository.stop(containerID: container.id)
            await refresh()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
    }

    func restart(_ container: Container) async
    {
        do
        {
            try await repository.restart(containerID: container.id)
            await refresh()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
    }
}

struct ContainersView: View
{
    @State private var vm: ContainersViewModel

    init(repository: any IContainerRepository)
    {
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
                Button { Task { await vm.refresh() } } label:
                {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white.opacity(0.7))
                }
                .buttonStyle(.plain)
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
                    ContainerRow(container: container)
                    { action in
                        Task
                        {
                            switch action
                            {
                                case .start:   await vm.start(container)
                                case .stop:    await vm.stop(container)
                                case .restart: await vm.restart(container)
                            }
                        }
                    }
                }
            }
            .padding(.top, 1)
        }
    }
}

enum ContainerAction { case start, stop, restart }

struct ContainerRow: View
{
    let container: Container
    let onAction: (ContainerAction) -> Void

    var body: some View
    {
        HStack(spacing: 14)
        {
            Circle()
                .fill(container.status.isRunning ? Color(hex: 0x4ADE80) : Color(hex: 0x555555))
                .frame(width: 8, height: 8)

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

            Text(container.status.rawValue)
                .foregroundColor(container.status.isRunning ? Color(hex: 0x4ADE80) : Color.white.opacity(0.4))
                .font(.system(size: 11, weight: .medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(container.status.isRunning
                              ? Color(hex: 0x4ADE80).opacity(0.12)
                              : Color.white.opacity(0.06))
                )

            HStack(spacing: 4)
            {
                if container.status.isRunning
                {
                    actionButton("stop.fill", color: Color(hex: 0xFF6B35)) { onAction(.stop) }
                    actionButton("arrow.clockwise", color: .white.opacity(0.5)) { onAction(.restart) }
                }
                else
                {
                    actionButton("play.fill", color: Color(hex: 0x4ADE80)) { onAction(.start) }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: 0x2A2A2A))
    }

    private func actionButton(_ icon: String, color: Color, action: @escaping () -> Void) -> some View
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
    }
}
