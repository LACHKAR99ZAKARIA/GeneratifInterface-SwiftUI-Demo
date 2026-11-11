import SwiftUI

struct ConversationView: View {
    let chatID: Chat.ID
    @Environment(ChatStore.self) private var store
    @State private var draft = ""
    @State private var showThemePicker = false

    var body: some View {
        AppScreen(background: .chat) {
            if let chat = store.chat(id: chatID) {
                messages(in: chat)
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        AppMessageInput(text: $draft, onSend: send)
                    }
                    .toolbar { toolbarContent(for: chat.contact) }
            } else {
                AppEmptyState(icon: AppIcons.chats, title: "Conversation introuvable")
            }
        }
        .environment(\.conversationStyle, store.chat(id: chatID).flatMap { store.style(for: $0) })
        .sheet(isPresented: $showThemePicker) { ConversationThemeSheet(chatID: chatID) }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
        .onAppear { store.markAsRead(chatID) }
    }

    @ViewBuilder
    private func messages(in chat: Chat) -> some View {
        if chat.messages.isEmpty {
            AppEmptyState(icon: AppIcons.chats, title: "Dites bonjour 👋",
                          message: "Envoyez votre premier message à \(chat.contact.name).")
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: AppSpacing.messageGap) {
                        ForEach(chat.messages) { AppMessageBubble(message: $0) }
                    }
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                    .padding(.vertical, AppSpacing.sm)
                }
                .defaultScrollAnchor(.bottom)
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: chat.messages.last?.id) { _, id in
                    guard let id else { return }
                    withAnimation(.easeOut(duration: 0.2)) { proxy.scrollTo(id, anchor: .bottom) }
                }
            }
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent(for contact: Contact) -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack(spacing: AppSpacing.componentGap) {
                AppAvatar(name: contact.name, size: .small)
                VStack(alignment: .leading, spacing: 0) {
                    Text(contact.name).font(AppTypography.headline).foregroundStyle(AppColors.textPrimary).lineLimit(1)
                    Text(contact.about).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary).lineLimit(1)
                }
            }
            .accessibilityElement(children: .combine)
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            AppIconButton(icon: AppIcons.appearance, accessibilityLabel: "Thème de la conversation") {
                showThemePicker = true
            }
            AppIconButton(icon: AppIcons.videoCall, accessibilityLabel: "Appel vidéo") {}
            AppIconButton(icon: AppIcons.audioCall, accessibilityLabel: "Appel audio") {}
        }
    }

    private func send() {
        store.send(draft, in: chatID)
        draft = ""
    }
}

#Preview("Conversation") {
    let store = ChatStore()
    return NavigationStack { ConversationView(chatID: store.chats[1].id) }
        .environment(store)
}
