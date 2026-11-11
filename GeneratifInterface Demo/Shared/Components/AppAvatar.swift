import SwiftUI

/// Avatar à initiales, couleur stable dérivée du nom. Anneau optionnel (statuts).
struct AppAvatar: View {
    enum Ring { case unseen, seen }

    let name: String
    var size: AppAvatarSize = .medium
    var ring: Ring?

    var body: some View {
        let diameter = size.points
        Text(initials)
            .font(.system(size: diameter * 0.38, weight: .semibold))
            .foregroundStyle(AppColors.textOnAccent)
            .frame(width: diameter, height: diameter)
            .background(AppColors.avatar(for: name), in: Circle())
            .overlay { ringOverlay(diameter: diameter) }
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private func ringOverlay(diameter: CGFloat) -> some View {
        if let ring {
            Circle()
                .strokeBorder(ring == .unseen ? AppColors.accent : AppColors.separator, lineWidth: 2.5)
                .padding(-AppSpacing.xs)
        }
    }

    private var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        return parts.compactMap { $0.first.map(String.init) }.joined().uppercased()
    }
}

#Preview {
    HStack(spacing: 16) {
        AppAvatar(name: "Sarah Benali", size: .small)
        AppAvatar(name: "Yassine El Amrani", ring: .unseen)
        AppAvatar(name: "Maman", size: .large, ring: .seen)
    }
    .padding()
}
