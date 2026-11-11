import SwiftUI

/// Choix du fond et des couleurs de texte/bulles d'une conversation.
struct ConversationThemeSheet: View {
    let chatID: Chat.ID
    @Environment(ChatStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: AppSpacing.md)]

    var body: some View {
        NavigationStack {
            AppScreen {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        tile(title: "Par défaut", style: nil)
                        ForEach(ConversationStyle.all) { tile(title: $0.name, style: $0) }
                        NavigationLink {
                            CustomConversationThemeView(chatID: chatID)
                        } label: {
                            tileContent(title: "Personnalisé", style: customStyle, isSelected: currentID == ConversationStyle.customID)
                        }
                        .buttonStyle(AppPressStyle())
                    }
                    .padding(AppSpacing.screenHorizontal)
                }
            }
            .navigationTitle("Thème de la conversation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    AppIconButton(icon: AppIcons.close, accessibilityLabel: "Fermer") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var currentID: String? { store.chat(id: chatID).flatMap { store.style(for: $0)?.id } }

    private var customStyle: ConversationStyle {
        .custom(store.customTheme(for: chatID) ?? .init())
    }

    private func tile(title: String, style: ConversationStyle?) -> some View {
        let isSelected = currentID == style?.id
        return Button {
            store.setTheme(style?.id, for: chatID)
        } label: {
            tileContent(title: title, style: style, isSelected: isSelected)
        }
        .buttonStyle(AppPressStyle())
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func tileContent(title: String, style: ConversationStyle?, isSelected: Bool) -> some View {
        VStack(spacing: AppSpacing.sm) {
                VStack(spacing: AppSpacing.xs) {
                    AppMessageBubble(message: Message(text: "Salut !", date: .now, isOutgoing: false))
                    AppMessageBubble(message: Message(text: "Aa", date: .now, isOutgoing: true, status: .read))
                }
                .environment(\.conversationStyle, style)
                .padding(AppSpacing.sm)
                .frame(maxWidth: .infinity)
                .background(style?.background.color ?? AppColors.chatBackground,
                            in: RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous)
                        .strokeBorder(isSelected ? AppColors.accent : AppColors.separator, lineWidth: isSelected ? 3 : 1)
                }
                Text(title)
                    .font(AppTypography.subheadline.weight(isSelected ? .semibold : .regular))
                    .foregroundStyle(AppColors.textPrimary)
            }
        .contentShape(Rectangle())
    }
}

#Preview {
    let store = ChatStore()
    return ConversationThemeSheet(chatID: store.chats[0].id).environment(store)
}
