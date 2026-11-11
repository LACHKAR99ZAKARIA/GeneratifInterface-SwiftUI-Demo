import SwiftUI

/// Éditeur de thème personnalisé : fond, bulles et textes au choix.
/// L'enregistrement est refusé tant qu'un texte est illisible (contraste < 4,5).
struct CustomConversationThemeView: View {
    let chatID: Chat.ID
    @Environment(ChatStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var custom = ConversationStyle.Custom()
    @State private var loaded = false

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.sectionGap) {
                    preview
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        AppSectionHeader(title: "Couleurs")
                        AppCard(padding: 0) {
                            VStack(spacing: 0) {
                                row("Arrière-plan", \.background)
                                AppDivider(leadingInset: AppSpacing.lg)
                                row("Bulle reçue", \.incomingBubble)
                                AppDivider(leadingInset: AppSpacing.lg)
                                row("Texte reçu", \.incomingText)
                                AppDivider(leadingInset: AppSpacing.lg)
                                row("Bulle envoyée", \.outgoingBubble)
                                AppDivider(leadingInset: AppSpacing.lg)
                                row("Texte envoyé", \.outgoingText)
                            }
                        }
                    }
                    if !custom.isReadable {
                        Text("Contraste trop faible : le texte doit être lisible sur sa bulle (minimum \(String(format: "%.1f", ConversationStyle.Custom.minimumContrast)) — reçu \(String(format: "%.1f", custom.incomingContrast)), envoyé \(String(format: "%.1f", custom.outgoingContrast))).")
                            .font(AppTypography.footnote)
                            .foregroundStyle(AppColors.textDestructive)
                    }
                    AppPrimaryButton(title: "Enregistrer", icon: AppIcons.checkmark) {
                        if store.setCustomTheme(custom, for: chatID) { dismiss() }
                    }
                    .disabled(!custom.isReadable)
                }
                .padding(AppSpacing.screenHorizontal)
            }
        }
        .navigationTitle("Thème personnalisé")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard !loaded else { return }
            loaded = true
            if let saved = store.customTheme(for: chatID) { custom = saved }
        }
    }

    private var preview: some View {
        VStack(spacing: AppSpacing.messageGap) {
            AppMessageBubble(message: Message(text: "Salut, tu as vu ?", date: .now, isOutgoing: false))
            AppMessageBubble(message: Message(text: "Oui, il est à moi 🎨", date: .now, isOutgoing: true, status: .read))
        }
        .environment(\.conversationStyle, .custom(custom))
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(hex: custom.background)),
                    in: RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
    }

    private func row(_ title: String, _ keyPath: WritableKeyPath<ConversationStyle.Custom, String>) -> some View {
        ColorPicker(selection: Binding(
            get: { Color(UIColor(hex: custom[keyPath: keyPath])) },
            set: { custom[keyPath: keyPath] = HexColor.hex(from: $0) }
        ), supportsOpacity: false) {
            Text(title).font(AppTypography.body).foregroundStyle(AppColors.textPrimary)
        }
        .padding(.horizontal, AppSpacing.lg)
        .frame(minHeight: AppIconSize.touchLarge)
    }
}

private extension UIColor {
    convenience init(hex: String) {
        let c = HexColor.components(hex) ?? (0, 0, 0, 1)
        self.init(red: c.r, green: c.g, blue: c.b, alpha: c.a)
    }
}
