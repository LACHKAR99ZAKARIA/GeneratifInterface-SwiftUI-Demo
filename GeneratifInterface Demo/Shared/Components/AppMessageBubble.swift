import SwiftUI

/// Coches d'état : envoyé (1 gris), remis (2 gris), lu (2 colorées).
struct AppReadReceipt: View {
    let status: MessageStatus

    var body: some View {
        ZStack {
            AppIcon(name: AppIcons.checkmark, size: .small, color: tint, weight: .semibold)
            if status != .sent {
                AppIcon(name: AppIcons.checkmark, size: .small, color: tint, weight: .semibold)
                    .offset(x: AppSpacing.xs + AppSpacing.xxs)
            }
        }
        .padding(.trailing, status == .sent ? 0 : AppSpacing.xs + AppSpacing.xxs)
        .accessibilityElement()
        .accessibilityLabel(label)
    }

    private var tint: Color { status == .read ? AppColors.readReceipt : AppColors.textSecondary }
    private var label: String {
        switch status {
        case .sent: "Envoyé"
        case .delivered: "Remis"
        case .read: "Lu"
        }
    }
}

struct AppMessageBubble: View {
    @Environment(\.conversationStyle) private var style
    let message: Message

    var body: some View {
        HStack(spacing: 0) {
            if message.isOutgoing { Spacer(minLength: AppSpacing.bubbleOppositeInset) }
            VStack(alignment: .trailing, spacing: AppSpacing.xxs) {
                Text(message.text)
                    .font(AppTypography.body)
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: AppSpacing.xs) {
                    Text(ChatDateFormatter.time(message.date))
                        .font(AppTypography.caption)
                        .foregroundStyle(textColor.opacity(0.7))
                    if message.isOutgoing { AppReadReceipt(status: message.status) }
                }
            }
            .padding(.horizontal, AppSpacing.bubbleHorizontal)
            .padding(.vertical, AppSpacing.bubbleVertical)
            .background(bubbleColor,
                        in: RoundedRectangle(cornerRadius: AppRadius.messageBubble, style: .continuous))
            .fixedSize(horizontal: message.text.count < 28, vertical: false)
            if !message.isOutgoing { Spacer(minLength: AppSpacing.bubbleOppositeInset) }
        }
        .accessibilityElement(children: .combine)
    }

    private var textColor: Color {
        if let style { return (message.isOutgoing ? style.outgoingText : style.incomingText).color }
        return message.isOutgoing ? AppColors.bubbleOutgoingText : AppColors.bubbleIncomingText
    }

    private var bubbleColor: Color {
        if let style { return (message.isOutgoing ? style.outgoingBubble : style.incomingBubble).color }
        return message.isOutgoing ? AppColors.bubbleOutgoing : AppColors.bubbleIncoming
    }
}

#Preview {
    AppScreen(background: .chat) {
        VStack(spacing: AppSpacing.messageGap) {
            AppMessageBubble(message: Message(text: "Salut !", date: .now, isOutgoing: false))
            AppMessageBubble(message: Message(text: "Tu as vu la maquette ? Elle change complètement avec la densité compacte.", date: .now, isOutgoing: true, status: .read))
            AppMessageBubble(message: Message(text: "Ok", date: .now, isOutgoing: true, status: .delivered))
        }
        .padding(AppSpacing.screenHorizontal)
    }
}
