import SwiftUI

private enum WindowPrefs {
    static let widthKey  = "windowWidth"
    static let heightKey = "windowHeight"
    static let defaultWidth:  CGFloat = 1100
    static let defaultHeight: CGFloat = 680

    static var savedSize: CGSize {
        let w = UserDefaults.standard.double(forKey: widthKey)
        let h = UserDefaults.standard.double(forKey: heightKey)
        guard w >= 800, h >= 500 else { return CGSize(width: defaultWidth, height: defaultHeight) }
        return CGSize(width: w, height: h)
    }

    static func save(_ size: CGSize) {
        UserDefaults.standard.set(size.width,  forKey: widthKey)
        UserDefaults.standard.set(size.height, forKey: heightKey)
    }
}

@main
struct ContainerUIApp: App {
    @State private var appState = AppState()
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "onboardingCompleted")
    private let initialSize = WindowPrefs.savedSize

    var body: some Scene {
        WindowGroup {
            Group
            {
                if showOnboarding
                {
                    OnboardingView { showOnboarding = false }
                        .transition(.opacity)
                }
                else
                {
                    HomeView(appState: appState)
                        .task { await appState.bootstrap() }
                        .onGeometryChange(for: CGSize.self, of: { $0.size })
                        { WindowPrefs.save($1) }
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.35), value: showOnboarding)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: initialSize.width, height: initialSize.height)
    }
}
