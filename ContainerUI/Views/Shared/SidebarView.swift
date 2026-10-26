import SwiftUI

enum SidebarSection: String, CaseIterable, Hashable {
    case containers   = "Containers"
    case images       = "Images"
    case registries   = "Registries"
    case documentation = "Documentation"
    case parameters   = "Parameters"

    var icon: String {
        switch self {
        case .containers:    return "shippingbox"
        case .images:        return "photo.on.rectangle"
        case .registries:    return "building.2"
        case .documentation: return "doc.text"
        case .parameters:    return "gearshape"
        }
    }
}

struct SidebarView: View {
    @Binding var selection: SidebarSection
    let containerCount: Int

    var body: some View {
        ZStack {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            VStack(spacing: 0) {
                ForEach(SidebarSection.allCases, id: \.self) { section in
                    SidebarRow(
                        section: section,
                        isSelected: selection == section,
                        badge: section == .containers && containerCount > 0 ? containerCount : nil
                    )
                    .onTapGesture { selection = section }
                }

                Spacer()
            }
            .padding(.top, 44)
        }
        .frame(width: 220)
    }
}

private struct SidebarRow: View {
    let section: SidebarSection
    let isSelected: Bool
    let badge: Int?

    var body: some View {
        HStack(spacing: 10) {
            if isSelected {
                Rectangle()
                    .fill(Color(hex: 0x4ADE80))
                    .frame(width: 3)
                    .cornerRadius(2)
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 3)
            }

            Image(systemName: section.icon)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.white)
                .frame(width: 22)

            Text(section.rawValue)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .regular))

            Spacer()

            if let count = badge {
                Text("\(count)")
                    .foregroundColor(Color(hex: 0xFF6B35))
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .strokeBorder(Color(hex: 0xFF6B35), lineWidth: 1.5)
                    )
            }

            Spacer().frame(width: 12)
        }
        .frame(height: 56)
        .background(isSelected ? Color.white.opacity(0.04) : Color.clear)
        .contentShape(Rectangle())
    }
}

#Preview {
    SidebarView(selection: .constant(.containers), containerCount: 4)
        .frame(height: 500)
}
