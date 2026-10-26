import SwiftUI

struct HomeView: View
{
    var appState: AppState
    @AppStorage("selectedSection") private var selectedSectionRaw: String = SidebarSection.containers.rawValue

    private var selectedSection: Binding<SidebarSection>
    {
        Binding(
            get: { SidebarSection(rawValue: selectedSectionRaw) ?? .containers },
            set: { selectedSectionRaw = $0.rawValue }
        )
    }

    var body: some View
    {
        switch appState.phase
        {
            case .loading(let message, let progress):
                LoadingView(message: message, progress: progress)
                    .frame(minWidth: 720, minHeight: 440)

            case .missingComponents(let reason):
                MissingComponentsView(
                    reason: reason,
                    isInstalling: false,
                    onInstall: {
                        switch reason
                        {
                            case .cliNotFound:
                                NSWorkspace.shared.open(URL(string: "https://github.com/apple/container#initial-install")!)
                            case .runtimeNotRunning:
                                Task { await appState.installComponents() }
                        }
                    },
                    onQuit: { appState.quit() }
                )
                .frame(minWidth: 720, minHeight: 440)

            case .installingComponents:
                MissingComponentsView(
                    reason: .runtimeNotRunning,
                    isInstalling: true,
                    onInstall: {},
                    onQuit: {}
                )
                .frame(minWidth: 720, minHeight: 440)

            case .ready:
                mainLayout
                    .frame(minWidth: 800, minHeight: 500)

            case .failed(let message):
                LoadingView(message: "Error: \(message)", progress: 0)
                    .frame(minWidth: 720, minHeight: 440)
        }
    }

    private var mainLayout: some View
    {
        HStack(spacing: 0)
        {
            SidebarView(selection: selectedSection, containerCount: appState.runningContainerCount)

            Divider()
                .background(Color.white.opacity(0.08))

            ZStack
            {
                Color(hex: 0x242424).ignoresSafeArea()

                switch selectedSection.wrappedValue
                {
                    case .containers:
                        ContainersView(repository: appState.containers)
                    case .images:
                        ImagesView(repository: appState.images)
                    case .registries:
                        RegistriesView(repository: appState.registries)
                    case .documentation, .parameters:
                        ComingSoonView(section: selectedSection.wrappedValue)
                }
            }
        }
        .background(Color(hex: 0x1D1D1D))
    }
}

struct ComingSoonView: View
{
    let section: SidebarSection

    var body: some View
    {
        VStack(spacing: 12)
        {
            Image(systemName: section.icon)
                .font(.system(size: 40, weight: .thin))
                .foregroundColor(.white.opacity(0.2))
            Text(section.rawValue)
                .foregroundColor(.white.opacity(0.3))
                .font(.system(size: 18, weight: .light))
            Text("Coming soon")
                .foregroundColor(.white.opacity(0.2))
                .font(.system(size: 12))
        }
    }
}

#Preview("HomeView — ready")
{
    let state = AppState()
    state.phase = .ready
    return HomeView(appState: state)
        .frame(width: 960, height: 600)
}

#Preview("HomeView — loading")
{
    HomeView(appState: {
        let s = AppState(); s.phase = .loading(message: "Connecting…", progress: 0.4); return s
    }())
    .frame(width: 960, height: 600)
}

#Preview("HomeView — missing CLI")
{
    HomeView(appState: {
        let s = AppState(); s.phase = .missingComponents(reason: .cliNotFound); return s
    }())
    .frame(width: 960, height: 600)
}

#Preview("ComingSoonView")
{
    ComingSoonView(section: .documentation)
        .frame(width: 600, height: 400)
        .background(Color(hex: 0x242424))
}
