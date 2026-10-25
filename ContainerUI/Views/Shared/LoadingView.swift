import SwiftUI

struct LoadingView: View {
    let message: String
    let progress: Double

    var body: some View {
        ZStack {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            VStack(spacing: 16) {
                Text(message)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 14, weight: .regular))

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(hex: 0x3A3A3A))
                            .frame(height: 6)

                        Capsule()
                            .fill(Color(hex: 0x4ADE80))
                            .frame(width: geo.size.width * progress, height: 6)
                            .animation(.easeInOut(duration: 0.4), value: progress)
                    }
                }
                .frame(width: 320, height: 6)
            }
        }
    }
}

#Preview {
    LoadingView(message: "Loading container system", progress: 0.6)
        .frame(width: 960, height: 540)
}
