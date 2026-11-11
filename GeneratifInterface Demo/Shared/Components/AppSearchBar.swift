import SwiftUI

/// Champ de recherche thématisé. États : normal, focus, avec texte (bouton effacer).
struct AppSearchBar: View {
    @Binding var text: String
    var prompt = "Rechercher"
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.componentGap) {
            AppIcon(name: AppIcons.search, size: .small, color: AppColors.iconSecondary)
            TextField(prompt, text: $text)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .focused($isFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button { text = "" } label: {
                    AppIcon(name: AppIcons.clear, size: .small, color: AppColors.iconSecondary)
                        .frame(width: AppIconSize.touchCompact, height: AppIconSize.touchCompact)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Effacer la recherche")
            }
        }
        .padding(.leading, AppSpacing.md)
        .padding(.trailing, text.isEmpty ? AppSpacing.md : 0)
        .frame(minHeight: AppIconSize.touchRegular - AppSpacing.xs)
        .background(AppColors.backgroundSecondary, in: RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(isFocused ? AppColors.accent : .clear, lineWidth: 1.5)
        }
        .animation(.easeOut(duration: 0.15), value: isFocused)
    }
}

#Preview {
    @Previewable @State var text = ""
    return AppScreen { AppSearchBar(text: $text).padding() }
}
