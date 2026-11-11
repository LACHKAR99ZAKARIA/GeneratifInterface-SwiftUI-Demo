import SwiftUI

// Tokens publics du Design System. Chaque accesseur lit `ThemeManager.shared`
// (observable) : une vue qui les utilise dans son `body` se met à jour seule.

private var theme: ThemeConfiguration { ThemeManager.shared.configuration }

// MARK: - AppColors

enum AppColors {
    private static var c: ThemeConfiguration.Colors { theme.colors }

    // Fonds
    static var background: Color { c.background.color }
    static var backgroundSecondary: Color { c.backgroundSecondary.color }
    static var chatBackground: Color { c.chatBackground.color }
    static var cardBackground: Color { c.cardBackground.color }
    static var buttonBackground: Color { c.buttonBackground.color }
    static var tabBarBackground: Color { c.tabBarBackground.color }
    // Textes
    static var textPrimary: Color { c.textPrimary.color }
    static var textSecondary: Color { c.textSecondary.color }
    static var textOnAccent: Color { c.textOnAccent.color }
    static var textDestructive: Color { c.textDestructive.color }
    // Icônes
    static var iconPrimary: Color { c.iconPrimary.color }
    static var iconSecondary: Color { c.iconSecondary.color }
    // Séparateurs
    static var separator: Color { c.separator.color }
    // Messages
    static var bubbleIncoming: Color { c.bubbleIncoming.color }
    static var bubbleOutgoing: Color { c.bubbleOutgoing.color }
    static var bubbleIncomingText: Color { c.bubbleIncomingText.color }
    static var bubbleOutgoingText: Color { c.bubbleOutgoingText.color }
    static var readReceipt: Color { c.readReceipt.color }
    // Accent & états
    static var accent: Color { c.accent.color }
    static var selectedBackground: Color { c.selectedBackground.color }
    static var disabledForeground: Color { c.disabledForeground.color }
    static var disabledBackground: Color { c.disabledBackground.color }

    /// Couleur d'avatar stable (indépendante de `hashValue`, aléatoire entre lancements).
    static func avatar(for name: String) -> Color {
        let palette = c.avatarPalette
        guard !palette.isEmpty else { return accent }
        let seed = name.unicodeScalars.reduce(0) { ($0 &* 31 &+ Int($1.value)) & 0x7FFF_FFFF }
        return palette[seed % palette.count].color
    }
}

// MARK: - AppSpacing

enum AppSpacing {
    private static var s: ThemeConfiguration.Spacing { theme.spacing }
    private static var k: CGFloat { theme.density.factor }
    private static func scaled(_ v: CGFloat) -> CGFloat { (v * k * 2).rounded() / 2 }

    static var xxs: CGFloat { scaled(s.xxs) }
    static var xs: CGFloat { scaled(s.xs) }
    static var sm: CGFloat { scaled(s.sm) }
    static var md: CGFloat { scaled(s.md) }
    static var lg: CGFloat { scaled(s.lg) }
    static var xl: CGFloat { scaled(s.xl) }
    static var xxl: CGFloat { scaled(s.xxl) }

    // Espacements sémantiques dérivés de l'échelle
    static var screenHorizontal: CGFloat { lg }
    static var sectionGap: CGFloat { xl }
    static var listRowVertical: CGFloat { sm }
    static var listRowHorizontal: CGFloat { lg }
    static var componentGap: CGFloat { sm }
    static var cardPadding: CGFloat { lg }
    static var bubbleHorizontal: CGFloat { md }
    static var bubbleVertical: CGFloat { sm }
    static var messageGap: CGFloat { xs }
    static var bubbleOppositeInset: CGFloat { xxl * 2 }
    static var inputPadding: CGFloat { sm }
}

// MARK: - AppRadius

enum AppRadius {
    private static var r: ThemeConfiguration.Radius { theme.radius }
    static var small: CGFloat { r.small }
    static var medium: CGFloat { r.medium }
    static var large: CGFloat { r.large }
    static var extraLarge: CGFloat { r.extraLarge }
    static var pill: CGFloat { 999 }
    static var messageBubble: CGFloat { r.messageBubble }
    static var card: CGFloat { r.card }
    static var button: CGFloat { r.button }
}

// MARK: - AppIconSize

enum AppIconSize {
    private static var i: ThemeConfiguration.IconMetrics { theme.icons }

    // Taille visuelle du symbole
    static var small: CGFloat { i.small }
    static var medium: CGFloat { i.medium }
    static var large: CGFloat { i.large }
    static var extraLarge: CGFloat { i.extraLarge }

    // Zone tactile (≥ 44 pt pour regular / large)
    static var touchCompact: CGFloat { i.touchCompact }
    static var touchRegular: CGFloat { i.touchRegular }
    static var touchLarge: CGFloat { i.touchLarge }

    enum Size {
        case small, medium, large, extraLarge
        var points: CGFloat {
            switch self {
            case .small: AppIconSize.small
            case .medium: AppIconSize.medium
            case .large: AppIconSize.large
            case .extraLarge: AppIconSize.extraLarge
            }
        }
    }

    enum Touch {
        case compact, regular, large
        var points: CGFloat {
            switch self {
            case .compact: AppIconSize.touchCompact
            case .regular: AppIconSize.touchRegular
            case .large: AppIconSize.touchLarge
            }
        }
    }
}

// MARK: - AppAvatarSize

enum AppAvatarSize {
    case small, medium, large
    var points: CGFloat {
        switch self {
        case .small: theme.components.avatarSmall
        case .medium: theme.components.avatarMedium
        case .large: theme.components.avatarLarge
        }
    }
}

// MARK: - AppComponentStyle

enum AppComponentStyle {
    static var cardStyle: ThemeConfiguration.CardStyle { theme.components.cardStyle }
    static var buttonStyle: ThemeConfiguration.ButtonStyleKind { theme.components.buttonStyle }
    static var buttonMinHeight: CGFloat { theme.components.buttonMinHeight }
}

// MARK: - AppTypography

enum AppTypography {
    private static var d: Font.Design { theme.typography.design.design }
    static var largeTitle: Font { .system(.largeTitle, design: d, weight: .bold) }
    static var title: Font { .system(.title2, design: d, weight: .semibold) }
    static var headline: Font { .system(.headline, design: d) }
    static var body: Font { .system(.body, design: d) }
    static var subheadline: Font { .system(.subheadline, design: d) }
    static var caption: Font { .system(.caption, design: d) }
    static var footnote: Font { .system(.footnote, design: d) }
}

// MARK: - AppIcons (SF Symbols)

enum AppIcons {
    // Navigation principale
    static let chats = "bubble.left.and.bubble.right"
    static let calls = "phone"
    static let settings = "gearshape"
    static let updates = "circle.dashed"
    // Actions
    static let search = "magnifyingglass"
    static let newMessage = "square.and.pencil"
    static let attachment = "plus"
    static let camera = "camera"
    static let microphone = "mic"
    static let send = "arrow.up"
    static let back = "chevron.left"
    static let menu = "ellipsis"
    static let notifications = "bell"
    static let status = "circle.dashed"
    static let clear = "xmark.circle.fill"
    static let close = "xmark"
    static let add = "plus"
    // Conversation / appels
    static let videoCall = "video"
    static let audioCall = "phone"
    static let callIncoming = "phone.arrow.down.left"
    static let callOutgoing = "phone.arrow.up.right"
    static let callMissed = "phone.arrow.down.left"
    static let checkmark = "checkmark"
    static let pin = "pin.fill"
    static let muted = "bell.slash.fill"
    static let chevron = "chevron.right"
    // Paramètres
    static let account = "key"
    static let privacy = "lock"
    static let chatsSettings = "message"
    static let storage = "externaldrive"
    static let appearance = "paintpalette"
    static let help = "questionmark.circle"
    static let invite = "person.2"
    static let channel = "megaphone"
    static let profile = "person.crop.circle"
    static let reset = "arrow.counterclockwise"
}
