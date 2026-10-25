import SwiftUI

@Observable @MainActor
private final class ContainerDetailViewModel
{
    var detail: ContainerDetail?
    var logs: String?
    var isLoadingDetail = true
    var isLoadingLogs = false
    var error: String?

    private let containerID: String
    private let repository: any IContainerRepository

    init(containerID: String, repository: any IContainerRepository)
    {
        self.containerID = containerID
        self.repository = repository
    }

    func load() async
    {
        isLoadingDetail = true
        error = nil
        do
        {
            detail = try await repository.inspect(containerID: containerID)
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
        isLoadingDetail = false
    }

    func loadLogs() async
    {
        isLoadingLogs = true
        do
        {
            logs = try await repository.logs(containerID: containerID)
        }
        catch let caughtError
        {
            logs = nil
            error = Errors.CLIMapper.map(caughtError).userMessage
        }
        isLoadingLogs = false
    }
}

// MARK: - View

struct ContainerDetailView: View
{
    let containerID: String
    let containerName: String
    let repository: any IContainerRepository

    @State private var vm: ContainerDetailViewModel
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss

    init(containerID: String, containerName: String, repository: any IContainerRepository)
    {
        self.containerID = containerID
        self.containerName = containerName
        self.repository = repository
        _vm = State(wrappedValue: ContainerDetailViewModel(containerID: containerID, repository: repository))
    }

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            VStack(spacing: 0)
            {
                header
                tabBar
                Divider().background(Color.white.opacity(0.08))

                if vm.isLoadingDetail
                {
                    Spacer()
                    ProgressView().progressViewStyle(.circular).tint(Color(hex: 0x4ADE80))
                    Spacer()
                }
                else if let detail = vm.detail
                {
                    switch selectedTab
                    {
                        case 0: detailTab(detail: detail)
                        case 1: logsTab
                        default: EmptyView()
                    }
                }
                else if let error = vm.error
                {
                    Spacer()
                    Text(error).foregroundColor(.white.opacity(0.5)).padding()
                    Spacer()
                }
            }
        }
        .frame(width: 680, height: 520)
        .task { await vm.load() }
        .onChange(of: selectedTab)
        { _, newTab in
            if newTab == 1 && vm.logs == nil { Task { await vm.loadLogs() } }
        }
    }

    // MARK: - Header

    private var header: some View
    {
        HStack
        {
            VStack(alignment: .leading, spacing: 2)
            {
                Text(containerName)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .semibold))
                Text(containerID)
                    .foregroundColor(.white.opacity(0.4))
                    .font(.system(size: 11, design: .monospaced))
            }
            Spacer()
            Button { dismiss() } label:
            {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 28, height: 28)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    // MARK: - Tab bar

    private var tabBar: some View
    {
        HStack(spacing: 0)
        {
            tabButton(title: "Details", index: 0)
            tabButton(title: "Logs", index: 1)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 1)
    }

    private func tabButton(title: String, index: Int) -> some View
    {
        Button { selectedTab = index } label:
        {
            VStack(spacing: 0)
            {
                Text(title)
                    .font(.system(size: 13, weight: selectedTab == index ? .semibold : .regular))
                    .foregroundColor(selectedTab == index ? .white : .white.opacity(0.4))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)

                Rectangle()
                    .fill(selectedTab == index ? Color(hex: 0x4ADE80) : Color.clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Detail tab

    private func detailTab(detail: ContainerDetail) -> some View
    {
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20)
            {
                detailSection(title: "Resources")
                {
                    detailRow("CPUs", value: "\(detail.configuration.resources.cpus)")
                    detailRow("Memory", value: detail.configuration.resources.memoryFormatted)
                }

                detailSection(title: "Process")
                {
                    detailRow("Executable", value: detail.configuration.initProcess.executable)
                    detailRow("Working dir", value: detail.configuration.initProcess.workingDirectory)
                }

                if !detail.configuration.initProcess.environment.isEmpty
                {
                    detailSection(title: "Environment")
                    {
                        ForEach(detail.configuration.initProcess.environment, id: \.self)
                        { env in
                            monoRow(env)
                        }
                    }
                }

                if !detail.configuration.mounts.isEmpty
                {
                    detailSection(title: "Mounts")
                    {
                        ForEach(detail.configuration.mounts)
                        { mount in
                            detailRow(mount.source, value: mount.destination)
                        }
                    }
                }

                if !detail.networks.isEmpty
                {
                    detailSection(title: "Networks")
                    {
                        ForEach(detail.networks)
                        { network in
                            detailRow(network.name ?? "—", value: network.address ?? "—")
                        }
                    }
                }
            }
            .padding(24)
        }
    }

    private func detailSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(hex: 0x4ADE80))
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 0)
            {
                content()
            }
            .background(Color(hex: 0x2A2A2A))
            .cornerRadius(8)
        }
    }

    private func detailRow(_ label: String, value: String) -> some View
    {
        HStack(alignment: .top)
        {
            Text(label)
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 12))
                .frame(width: 120, alignment: .leading)
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 12))
                .textSelection(.enabled)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
    }

    private func monoRow(_ text: String) -> some View
    {
        Text(text)
            .foregroundColor(.white.opacity(0.8))
            .font(.system(size: 11, design: .monospaced))
            .textSelection(.enabled)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
    }

    // MARK: - Logs tab

    private var logsTab: some View
    {
        Group
        {
            if vm.isLoadingLogs
            {
                Spacer()
                ProgressView().progressViewStyle(.circular).tint(Color(hex: 0x4ADE80))
                Spacer()
            }
            else if let logs = vm.logs, !logs.isEmpty
            {
                ScrollViewReader
                { proxy in
                    ScrollView
                    {
                        Text(logs)
                            .foregroundColor(Color(hex: 0x4ADE80).opacity(0.9))
                            .font(.system(size: 11, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .id("bottom")
                    }
                    .background(Color(hex: 0x111111))
                    .onAppear { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }
            else
            {
                VStack(spacing: 12)
                {
                    Image(systemName: "doc.text")
                        .font(.system(size: 32, weight: .thin))
                        .foregroundColor(.white.opacity(0.2))
                    Text("No logs available")
                        .foregroundColor(.white.opacity(0.3))
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
