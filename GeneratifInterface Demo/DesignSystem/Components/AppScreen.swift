import SwiftUI

/// Conteneur commun de tous les écrans : applique le fond centralisé via un
/// unique `ZStack`. Le contenu garde ses propres safe areas (les listes et
/// scroll views défilent donc naturellement sous les barres).
struct AppScreen<Content: View>: View {
    enum Background { case standard, secondary, chat }

    @Environment(\.conversationStyle) private var conversationStyle
    var background: Background = .standard
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            content
        }
    }

    private var backgroundColor: Color {
        switch background {
        case .standard: AppColors.background
        case .secondary: AppColors.backgroundSecondary
        case .chat: conversationStyle?.background.color ?? AppColors.chatBackground
        }
    }
}
