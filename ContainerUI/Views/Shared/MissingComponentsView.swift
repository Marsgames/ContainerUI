import SwiftUI

struct MissingComponentsView: View {
    let isInstalling: Bool
    let onInstall: () -> Void
    let onQuit: () -> Void

    var body: some View {
        ZStack {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: 0x2C2C2C))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                )
                .frame(width: 440, height: 220)

            VStack(spacing: 12) {
                Text("Missing required components")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))

                Text("Would you like to install them?")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 13))

                Spacer().frame(height: 8)

                if isInstalling {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color(hex: 0x4ADE80))
                } else {
                    Button(action: onInstall) {
                        Text("Yes please")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 200, height: 40)
                            .background(
                                Capsule().fill(Color(hex: 0x4ADE80))
                            )
                    }
                    .buttonStyle(.plain)

                    Button(action: onQuit) {
                        Text("No thanks, quit")
                            .foregroundColor(Color(hex: 0xFF4444))
                            .font(.system(size: 13))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(width: 440)
        }
    }
}

#Preview {
    MissingComponentsView(isInstalling: false, onInstall: {}, onQuit: {})
        .frame(width: 960, height: 540)
}
