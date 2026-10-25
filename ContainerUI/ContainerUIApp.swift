import SwiftUI

@main
struct ContainerUIApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .task { await appState.bootstrap() }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1100, height: 680)
    }
}
