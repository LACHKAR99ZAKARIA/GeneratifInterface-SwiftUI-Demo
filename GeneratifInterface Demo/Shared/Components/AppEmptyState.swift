import SwiftUI

struct AppEmptyState: View {
    let icon: String
    let title: String
    var message: String?
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            AppIcon(name: icon, size: .extraLarge, color: AppColors.iconSecondary)
            Text(title)
                .font(AppTypography.title)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            if let message {
                Text(message)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            if let actionTitle, let action {
                AppPrimaryButton(title: actionTitle, fillsWidth: false, action: action)
                    .padding(.top, AppSpacing.sm)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    AppScreen {
        AppEmptyState(icon: AppIcons.chats, title: "Aucune discussion",
                      message: "Commencez une nouvelle conversation.", actionTitle: "Nouveau message") {}
    }
}
