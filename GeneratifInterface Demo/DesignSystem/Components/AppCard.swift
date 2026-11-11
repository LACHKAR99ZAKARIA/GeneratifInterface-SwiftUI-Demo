import SwiftUI

/// Carte standard. Le style (plat / bordure / ombre) vient du thème.
struct AppCard<Content: View>: View {
    var isSelected = false
    var padding: CGFloat?
    @ViewBuilder var content: Content

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous)
        content
            .padding(padding ?? AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? AppColors.selectedBackground : AppColors.cardBackground, in: shape)
            .overlay {
                if isSelected {
                    shape.strokeBorder(AppColors.accent, lineWidth: 1.5)
                } else if AppComponentStyle.cardStyle == .bordered {
                    shape.strokeBorder(AppColors.separator, lineWidth: 1)
                }
            }
            .shadow(color: AppComponentStyle.cardStyle == .elevated ? .black.opacity(0.12) : .clear,
                    radius: 8, y: 3)
    }
}

/// Trait fin, aligné sur un pixel physique.
struct AppDivider: View {
    @Environment(\.displayScale) private var displayScale
    var leadingInset: CGFloat = 0

    var body: some View {
        Rectangle()
            .fill(AppColors.separator)
            .frame(height: 1 / displayScale)
            .padding(.leading, leadingInset)
            .accessibilityHidden(true)
    }
}

struct AppSectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.subheadline.weight(.semibold))
                .foregroundStyle(AppColors.textSecondary)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.accent)
            }
        }
    }
}

#Preview {
    AppScreen {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            AppSectionHeader(title: "Section", actionTitle: "Tout voir") {}
            AppCard { Text("Contenu de la carte").font(AppTypography.body).foregroundStyle(AppColors.textPrimary) }
            AppCard(isSelected: true) { Text("Sélectionnée").foregroundStyle(AppColors.textPrimary) }
            AppDivider()
        }
        .padding(AppSpacing.screenHorizontal)
    }
}
