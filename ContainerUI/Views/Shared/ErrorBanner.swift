import SwiftUI

struct ErrorBanner: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle")
                .foregroundColor(Color(hex: 0xFF4444))
            Text(message)
                .foregroundColor(.white.opacity(0.85))
                .font(.system(size: 12))
                .lineLimit(2)
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 11))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(hex: 0x2C2020).opacity(0.95))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(hex: 0xFF4444).opacity(0.4), lineWidth: 1)
        )
    }
}
