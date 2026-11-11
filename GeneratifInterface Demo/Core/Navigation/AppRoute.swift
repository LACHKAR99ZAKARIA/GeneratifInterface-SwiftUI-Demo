import Foundation

/// Destinations typées de la `NavigationStack` (Discussions).
enum AppRoute: Hashable {
    case conversation(Chat.ID)
}

enum AppTab: Hashable {
    case updates, calls, chats, settings
}
