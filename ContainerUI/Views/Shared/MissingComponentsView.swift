import SwiftUI

struct MissingComponentsView: View
{
    let reason: MissingComponentsReason
    let isInstalling: Bool
    let onInstall: () -> Void
    let onQuit: () -> Void

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: 0x2C2C2C))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                )
                .frame(width: 460, height: 260)

            VStack(spacing: 10)
            {
                Image(systemName: reason.icon)
                    .font(.system(size: 28, weight: .thin))
                    .foregroundColor(.white.opacity(0.5))

                Text(reason.title)
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)

                Text(reason.detail)
                    .foregroundColor(.white.opacity(0.55))
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 360)

                Spacer().frame(height: 4)

                if isInstalling
                {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color(hex: 0x4ADE80))
                }
                else
                {
                    Button(action: onInstall)
                    {
                        Text(reason.actionLabel)
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 220, height: 40)
                            .background(Capsule().fill(Color(hex: 0x4ADE80)))
                    }
                    .buttonStyle(.plain)

                    Button(action: onQuit)
                    {
                        Text("No thanks, quit")
                            .foregroundColor(Color(hex: 0xFF4444))
                            .font(.system(size: 13))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(width: 460)
        }
    }
}

// MARK: - MissingComponentsReason display helpers

private extension MissingComponentsReason
{
    var icon: String
    {
        switch self
        {
            case .cliNotFound:      return "exclamationmark.triangle"
            case .runtimeNotRunning: return "bolt.slash"
        }
    }

    var title: String
    {
        switch self
        {
            case .cliNotFound:       return "Container system not installed"
            case .runtimeNotRunning: return "Container runtime not running"
        }
    }

    var detail: String
    {
        switch self
        {
            case .cliNotFound:
                return "The container CLI was not found at /usr/local/bin/container.\nMake sure Apple's container system is installed on this Mac."
            case .runtimeNotRunning:
                return "The container CLI is installed but the background service is not running.\nContainerUI can start it for you."
        }
    }

    var actionLabel: String
    {
        switch self
        {
            case .cliNotFound:       return "Open installation guide"
            case .runtimeNotRunning: return "Start container service"
        }
    }
}

#Preview("CLI not found")
{
    MissingComponentsView(reason: .cliNotFound, isInstalling: false, onInstall: {}, onQuit: {})
        .frame(width: 960, height: 540)
}

#Preview("Runtime not running")
{
    MissingComponentsView(reason: .runtimeNotRunning, isInstalling: false, onInstall: {}, onQuit: {})
        .frame(width: 960, height: 540)
}
