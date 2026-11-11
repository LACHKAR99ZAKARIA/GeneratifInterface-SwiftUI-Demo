import SwiftUI

struct ChatsView: View {
    @Environment(ChatStore.self) private var store
    @State private var path: [AppRoute] = []
    @State private var query = ""
    @State private var showNewChat = false

    var body: some View {
        NavigationStack(path: $path) {
            let chats = store.chats(matching: query)
            AppScreen {
                List {
                    AppSearchBar(text: $query)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(rowInsets)
                    ForEach(chats) { chat in
                        NavigationLink(value: AppRoute.conversation(chat.id)) {
                            AppChatRow(chat: chat)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(AppColors.separator)
                        .listRowInsets(rowInsets)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .overlay {
                    if chats.isEmpty {
                        AppEmptyState(icon: AppIcons.chats,
                                      title: query.isEmpty ? "Aucune discussion" : "Aucun résultat",
                                      message: query.isEmpty ? "Démarrez une conversation avec un contact."
                                                             : "Aucune discussion ne correspond à « \(query) ».",
                                      actionTitle: query.isEmpty ? "Nouveau message" : nil) { showNewChat = true }
                    }
                }
            }
            .navigationTitle("Discussions")
            .toolbar { toolbarContent }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .conversation(let id): ConversationView(chatID: id)
                }
            }
            .sheet(isPresented: $showNewChat) {
                NewChatView { contact in
                    path.append(.conversation(store.chatID(for: contact)))
                }
            }
        }
    }

    private var rowInsets: EdgeInsets {
        EdgeInsets(top: AppSpacing.listRowVertical, leading: AppSpacing.listRowHorizontal,
                   bottom: AppSpacing.listRowVertical, trailing: AppSpacing.listRowHorizontal)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Button("Nouveau groupe", systemImage: AppIcons.invite) { showNewChat = true }
                Button("Notifications", systemImage: AppIcons.notifications) {}
            } label: {
                AppIcon(name: AppIcons.menu)
                    .frame(width: AppIconSize.touchRegular, height: AppIconSize.touchRegular)
            }
            .accessibilityLabel("Menu")
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            AppIconButton(icon: AppIcons.camera, accessibilityLabel: "Caméra") {}
            AppIconButton(icon: AppIcons.newMessage, accessibilityLabel: "Nouveau message") { showNewChat = true }
        }
    }
}

/// Feuille de sélection d'un contact pour démarrer une conversation.
struct NewChatView: View {
    @Environment(ChatStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let onSelect: (Contact) -> Void

    var body: some View {
        NavigationStack {
            AppScreen {
                List(store.contacts) { contact in
                    Button {
                        dismiss()
                        onSelect(contact)
                    } label: {
                        HStack(spacing: AppSpacing.md) {
                            AppAvatar(name: contact.name, size: .small)
                            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                                Text(contact.name).font(AppTypography.headline).foregroundStyle(AppColors.textPrimary)
                                Text(contact.about).font(AppTypography.subheadline).foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(AppColors.separator)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Nouveau message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    AppIconButton(icon: AppIcons.close, accessibilityLabel: "Fermer") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview("Discussions") {
    ChatsView().environment(ChatStore())
}
