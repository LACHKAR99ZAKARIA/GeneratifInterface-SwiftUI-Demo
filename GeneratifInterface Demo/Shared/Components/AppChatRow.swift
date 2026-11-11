import SwiftUI

/// Ligne de discussion : avatar, nom, dernier message, heure, badge non lus.
struct AppChatRow: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            AppAvatar(name: chat.contact.name)
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                HStack(alignment: .firstTextBaseline) {
                    Text(chat.contact.name)
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    Spacer(minLength: AppSpacing.sm)
                    if let last = chat.lastMessage {
                        Text(ChatDateFormatter.listLabel(for: last.date))
                            .font(AppTypography.caption)
                            .foregroundStyle(chat.unreadCount > 0 ? AppColors.accent : AppColors.textSecondary)
                    }
                }
                HStack(spacing: AppSpacing.xs) {
                    if let last = chat.lastMessage, last.isOutgoing {
                        AppReadReceipt(status: last.status)
                    }
                    Text(chat.lastMessage?.text ?? "Aucun message")
                        .font(AppTypography.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(2)
                    Spacer(minLength: AppSpacing.sm)
                    trailingIndicators
                }
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityHint(chat.unreadCount > 0 ? "\(chat.unreadCount) messages non lus" : "")
    }

    @ViewBuilder
    private var trailingIndicators: some View {
        HStack(spacing: AppSpacing.xs) {
            if chat.isMuted { AppIcon(name: AppIcons.muted, size: .small, color: AppColors.iconSecondary) }
            if chat.unreadCount > 0 {
                Text("\(chat.unreadCount)")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(AppColors.textOnAccent)
                    .padding(.horizontal, AppSpacing.sm)
                    .frame(minWidth: AppIconSize.small + AppSpacing.sm, minHeight: AppIconSize.small + AppSpacing.xs)
                    .background(AppColors.accent, in: Capsule())
            } else if chat.isPinned {
                AppIcon(name: AppIcons.pin, size: .small, color: AppColors.iconSecondary)
            }
        }
    }
}

#Preview {
    List(MockData.makeChats()) { AppChatRow(chat: $0) }
        .listStyle(.plain)
}
