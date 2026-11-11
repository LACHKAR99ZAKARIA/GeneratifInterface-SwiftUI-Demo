import SwiftUI

/// Racine de l'application : TabView native + thème appliqué globalement.
struct ContentView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(ChatStore.self) private var store
    @State private var selection: AppTab = .chats

    var body: some View {
        AppTabBar(selection: $selection, chatsBadge: store.totalUnread) {
            UpdatesView()
        } calls: {
            CallsView()
        } chats: {
            ChatsView()
        } settings: {
            SettingsView()
        }
        .preferredColorScheme(theme.configuration.appearance.colorScheme)
    }
}

#Preview("Clair") {
    ContentView().environment(ThemeManager.shared).environment(ChatStore())
}

#Preview("Sombre") {
    ContentView().environment(ThemeManager.shared).environment(ChatStore())
        .preferredColorScheme(.dark)
}
