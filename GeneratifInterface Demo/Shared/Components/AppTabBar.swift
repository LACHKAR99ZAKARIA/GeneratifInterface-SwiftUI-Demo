import SwiftUI

/// Enveloppe la `TabView` native : on garde le comportement iOS (Liquid Glass,
/// accessibilité, iPad) et on n'applique que les couleurs du Design System.
struct AppTabBar<Chats: View, Calls: View, Updates: View, Settings: View>: View {
    @Binding var selection: AppTab
    var chatsBadge = 0
    @ViewBuilder var updates: Updates
    @ViewBuilder var calls: Calls
    @ViewBuilder var chats: Chats
    @ViewBuilder var settings: Settings

    var body: some View {
        TabView(selection: $selection) {
            Tab("Actus", systemImage: AppIcons.updates, value: AppTab.updates) { updates }
            Tab("Appels", systemImage: AppIcons.calls, value: AppTab.calls) { calls }
            Tab("Discussions", systemImage: AppIcons.chats, value: AppTab.chats) { chats }
                .badge(chatsBadge)
            Tab("Réglages", systemImage: AppIcons.settings, value: AppTab.settings) { settings }
        }
        .tint(AppColors.accent)
        .toolbarBackground(AppColors.tabBarBackground, for: .tabBar)
    }
}
