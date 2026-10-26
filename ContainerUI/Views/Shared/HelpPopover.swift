import SwiftUI

struct HelpPopover: View
{
    let title: String
    let helpText: String

    var body: some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)

            Text(helpText)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.65))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(width: 280)
        .background(Color(hex: 0x2A2A2A))
    }
}

struct HelpToolbarButton: View
{
    let title: String
    let helpText: String
    @State private var isShowingPopover = false

    var body: some View
    {
        Button { isShowingPopover.toggle() } label:
        {
            Image(systemName: "questionmark.circle")
                .foregroundColor(.white.opacity(0.45))
                .padding(.horizontal, 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Help")
        .popover(isPresented: $isShowingPopover, arrowEdge: .bottom)
        {
            HelpPopover(title: title, helpText: helpText)
        }
    }
}

#Preview("HelpPopover")
{
    HelpPopover(
        title: "Containers",
        helpText: "This list shows all containers on your system — running and stopped.\n\n• Tap a row to inspect details and logs.\n• Use ▶ to start, ■ to stop, ↺ to restart."
    )
}

#Preview("HelpToolbarButton")
{
    HelpToolbarButton(
        title: "Images",
        helpText: "Local images pulled from a registry or built from a Dockerfile."
    )
    .padding()
    .background(Color(hex: 0x1D1D1D))
}
