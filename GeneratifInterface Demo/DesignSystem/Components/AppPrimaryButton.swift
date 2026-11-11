import SwiftUI

/// Bouton principal. États : normal, pressed, disabled, loading.
struct AppPrimaryButton: View {
    let title: String
    var icon: String?
    var isLoading = false
    var fillsWidth = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            AppPrimaryButtonLabel(title: title, icon: icon, isLoading: isLoading, fillsWidth: fillsWidth)
        }
        .buttonStyle(AppPressStyle())
        .disabled(isLoading)
    }
}

private struct AppPrimaryButtonLabel: View {
    @Environment(\.isEnabled) private var isEnabled
    let title: String
    let icon: String?
    let isLoading: Bool
    let fillsWidth: Bool

    var body: some View {
        HStack(spacing: AppSpacing.componentGap) {
            if isLoading {
                ProgressView().tint(foreground)
            } else if let icon {
                AppIcon(name: icon, size: .small, color: foreground, weight: .semibold)
            }
            Text(title).font(AppTypography.headline)
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, AppSpacing.xl)
        .frame(maxWidth: fillsWidth ? .infinity : nil, minHeight: AppComponentStyle.buttonMinHeight)
        .background(background, in: RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous))
        .contentShape(Rectangle())
    }

    private var tinted: Bool { AppComponentStyle.buttonStyle == .tinted }

    private var foreground: Color {
        if !isEnabled && !isLoading { return AppColors.disabledForeground }
        return tinted ? AppColors.accent : AppColors.textOnAccent
    }

    private var background: Color {
        if !isEnabled && !isLoading { return AppColors.disabledBackground }
        return tinted ? AppColors.selectedBackground : AppColors.buttonBackground
    }
}

#Preview {
    VStack(spacing: 12) {
        AppPrimaryButton(title: "Continuer", icon: AppIcons.send) {}
        AppPrimaryButton(title: "Chargement", isLoading: true) {}
        AppPrimaryButton(title: "Désactivé") {}.disabled(true)
    }
    .padding()
}
