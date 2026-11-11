import Foundation
import Observation

/// Source de vérité des conversations (en mémoire). Logique testable, sans UI.
@Observable
final class ChatStore {
    private(set) var chats: [Chat]
    let calls: [CallRecord]
    let statuses: [StatusUpdate]
    let channels: [Channel]
    let contacts: [Contact]
    /// Thème par conversation (clé = nom du contact, stable entre lancements).
    private(set) var themeIDs: [String: String]
    private let defaults: UserDefaults
    private static let themesKey = "conversation.themes.v1"
    private static let customKey = "conversation.customThemes.v1"
    /// Thèmes personnalisés (clé = nom du contact).
    private(set) var customThemes: [String: ConversationStyle.Custom]

    init(defaults: UserDefaults = .standard,
         chats: [Chat] = MockData.makeChats(),
         calls: [CallRecord] = MockData.makeCalls(),
         statuses: [StatusUpdate] = MockData.makeStatuses(),
         channels: [Channel] = MockData.channels,
         contacts: [Contact] = MockData.contacts.filter { !$0.isGroup }) {
        self.chats = chats
        self.calls = calls
        self.statuses = statuses
        self.channels = channels
        self.contacts = contacts
        self.defaults = defaults
        self.themeIDs = defaults.dictionary(forKey: Self.themesKey) as? [String: String] ?? [:]
        self.customThemes = defaults.data(forKey: Self.customKey)
            .flatMap { try? JSONDecoder().decode([String: ConversationStyle.Custom].self, from: $0) } ?? [:]
    }

    func style(for chat: Chat) -> ConversationStyle? {
        let name = chat.contact.name
        if themeIDs[name] == ConversationStyle.customID {
            return customThemes[name].map { ConversationStyle.custom($0) }
        }
        return ConversationStyle.preset(id: themeIDs[name])
    }

    func customTheme(for chatID: Chat.ID) -> ConversationStyle.Custom? {
        chat(id: chatID).flatMap { customThemes[$0.contact.name] }
    }

    /// Enregistre et active un thème personnalisé (refusé s'il est illisible).
    @discardableResult
    func setCustomTheme(_ custom: ConversationStyle.Custom, for chatID: Chat.ID) -> Bool {
        guard custom.isReadable, let chat = chat(id: chatID) else { return false }
        customThemes[chat.contact.name] = custom
        themeIDs[chat.contact.name] = ConversationStyle.customID
        defaults.set(try? JSONEncoder().encode(customThemes), forKey: Self.customKey)
        defaults.set(themeIDs, forKey: Self.themesKey)
        return true
    }

    /// `nil` rétablit le thème global.
    func setTheme(_ styleID: String?, for chatID: Chat.ID) {
        guard let chat = chat(id: chatID) else { return }
        themeIDs[chat.contact.name] = styleID
        defaults.set(themeIDs, forKey: Self.themesKey)
    }

    var totalUnread: Int { chats.reduce(0) { $0 + $1.unreadCount } }

    /// Conversations filtrées, épinglées d'abord puis par date décroissante.
    func chats(matching query: String) -> [Chat] {
        let q = query.trimmingCharacters(in: .whitespaces)
        return chats
            .filter { q.isEmpty || $0.contact.name.localizedStandardContains(q)
                || ($0.lastMessage?.text.localizedStandardContains(q) ?? false) }
            .sorted {
                if $0.isPinned != $1.isPinned { return $0.isPinned }
                return ($0.lastMessage?.date ?? .distantPast) > ($1.lastMessage?.date ?? .distantPast)
            }
    }

    func chat(id: Chat.ID) -> Chat? { chats.first { $0.id == id } }

    /// Retourne la conversation existante avec ce contact, ou en crée une vide.
    func chatID(for contact: Contact) -> Chat.ID {
        if let existing = chats.first(where: { $0.contact.id == contact.id }) { return existing.id }
        let chat = Chat(contact: contact)
        chats.append(chat)
        return chat.id
    }

    func markAsRead(_ id: Chat.ID) {
        guard let i = chats.firstIndex(where: { $0.id == id }), chats[i].unreadCount > 0 else { return }
        chats[i].unreadCount = 0
    }

    /// Ajoute un message sortant puis simule sa remise et sa lecture.
    func send(_ text: String, in id: Chat.ID) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let i = chats.firstIndex(where: { $0.id == id }) else { return }
        let message = Message(text: trimmed, date: .now, isOutgoing: true, status: .sent)
        chats[i].messages.append(message)
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(0.8))
            self?.setStatus(.delivered, for: message.id, in: id)
            try? await Task.sleep(for: .seconds(1.2))
            self?.setStatus(.read, for: message.id, in: id)
        }
    }

    private func setStatus(_ status: MessageStatus, for messageID: Message.ID, in chatID: Chat.ID) {
        guard let c = chats.firstIndex(where: { $0.id == chatID }),
              let m = chats[c].messages.firstIndex(where: { $0.id == messageID }) else { return }
        chats[c].messages[m].status = status
    }
}
