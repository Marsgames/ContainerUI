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
