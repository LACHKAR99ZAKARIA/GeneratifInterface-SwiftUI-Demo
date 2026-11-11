import SwiftUI

// MARK: - ThemeConfiguration
//
// Source unique de vérité des valeurs visuelles. C'est ICI que l'on modifie
// une valeur par défaut (couleur, radius, espacement, taille d'icône…).
// Cette structure est `Codable` : c'est le format qu'une future IA générative
// pourra produire (JSON) avant validation par `ThemeManager.apply(jsonData:)`.

struct ThemeConfiguration: Codable, Equatable {
    var schemaVersion = 1
    var appearance: Appearance = .system
    var density: Density = .regular
    var colors: Colors = .default
    var spacing: Spacing = .default
    var radius: Radius = .default
    var icons: IconMetrics = .default
    var components: ComponentStyles = .default
    var typography: Typography = .default

    static let `default` = ThemeConfiguration()
}

// MARK: Enums de configuration

extension ThemeConfiguration {
    enum Appearance: String, Codable, CaseIterable, Identifiable {
        case system, light, dark
        var id: String { rawValue }
        var colorScheme: ColorScheme? {
            switch self {
            case .system: nil
            case .light: .light
            case .dark: .dark
            }
        }
        var label: String {
            switch self {
            case .system: "Auto"
            case .light: "Clair"
            case .dark: "Sombre"
            }
        }
    }

    /// Densité globale : multiplie tous les espacements.
    enum Density: String, Codable, CaseIterable, Identifiable {
        case compact, regular, comfortable
        var id: String { rawValue }
        var factor: CGFloat {
            switch self {
            case .compact: 0.8
            case .regular: 1
            case .comfortable: 1.2
            }
        }
        var label: String {
            switch self {
            case .compact: "Compacte"
            case .regular: "Normale"
            case .comfortable: "Aérée"
            }
        }
    }

    enum CardStyle: String, Codable, CaseIterable, Identifiable {
        case flat, bordered, elevated
        var id: String { rawValue }
        var label: String {
            switch self {
            case .flat: "Plat"
            case .bordered: "Bordure"
            case .elevated: "Ombre"
            }
        }
    }

    enum ButtonStyleKind: String, Codable, CaseIterable {
        case filled, tinted
    }

    enum FontDesign: String, Codable, CaseIterable {
        case standard, rounded, serif
        var design: Font.Design {
            switch self {
            case .standard: .default
            case .rounded: .rounded
            case .serif: .serif
            }
        }
    }
}

// MARK: Couleurs

extension ThemeConfiguration {
    /// Paire de couleurs hexadécimales (`#RRGGBB` ou `#RRGGBBAA`) Light / Dark.
    struct ColorPair: Codable, Equatable {
        var light: String
        var dark: String
        init(_ light: String, _ dark: String) {
            self.light = light
            self.dark = dark
        }
    }

    struct Colors: Codable, Equatable {
        // Fonds
        var background = ColorPair("#FFFFFF", "#0B141A")
        var backgroundSecondary = ColorPair("#F0F2F5", "#111B21")
        var chatBackground = ColorPair("#EFEAE2", "#0B141A")
        var cardBackground = ColorPair("#F0F2F5", "#1F2C34")
        var buttonBackground = ColorPair("#00765F", "#25D366")
        var tabBarBackground = ColorPair("#F7F8FA", "#111B21")
        // Textes
        var textPrimary = ColorPair("#111B21", "#E9EDEF")
        var textSecondary = ColorPair("#5B6B75", "#8696A0")
        var textOnAccent = ColorPair("#FFFFFF", "#0B141A")
        var textDestructive = ColorPair("#C5221F", "#F15C6D")
        // Icônes
        var iconPrimary = ColorPair("#54656F", "#AEBAC1")
        var iconSecondary = ColorPair("#8696A0", "#8696A0")
        // Séparateurs
        var separator = ColorPair("#E1E5E8", "#222D34")
        // Messages
        var bubbleIncoming = ColorPair("#FFFFFF", "#1F2C34")
        var bubbleOutgoing = ColorPair("#D9FDD3", "#005C4B")
        var bubbleIncomingText = ColorPair("#111B21", "#E9EDEF")
        var bubbleOutgoingText = ColorPair("#111B21", "#E9EDEF")
        var readReceipt = ColorPair("#2B8FC4", "#53BDEB")
        // Accent & états
        var accent = ColorPair("#00765F", "#25D366")
        var selectedBackground = ColorPair("#E3F3EE", "#1B3A36")
        var disabledForeground = ColorPair("#9AA7AE", "#5B6A73")
        var disabledBackground = ColorPair("#E4E8EB", "#26333B")
        // Palette des avatars (initiales)
        var avatarPalette: [ColorPair] = [
            ColorPair("#5E6EC2", "#7F8DE0"),
            ColorPair("#B04E8A", "#D97BB3"),
            ColorPair("#C26E2E", "#E8985A"),
            ColorPair("#2E8F8A", "#4FC3BD"),
            ColorPair("#7B5BB5", "#A387DB"),
            ColorPair("#C2493F", "#EA7A70")
        ]

        static let `default` = Colors()

        /// Toutes les paires nommées (utilisé par la validation).
        var named: [(name: String, pair: ColorPair)] {
            [("background", background), ("backgroundSecondary", backgroundSecondary),
             ("chatBackground", chatBackground), ("cardBackground", cardBackground),
             ("buttonBackground", buttonBackground), ("tabBarBackground", tabBarBackground),
             ("textPrimary", textPrimary), ("textSecondary", textSecondary),
             ("textOnAccent", textOnAccent), ("textDestructive", textDestructive),
             ("iconPrimary", iconPrimary), ("iconSecondary", iconSecondary),
             ("separator", separator), ("bubbleIncoming", bubbleIncoming),
             ("bubbleOutgoing", bubbleOutgoing), ("bubbleIncomingText", bubbleIncomingText),
             ("bubbleOutgoingText", bubbleOutgoingText), ("readReceipt", readReceipt),
             ("accent", accent), ("selectedBackground", selectedBackground),
             ("disabledForeground", disabledForeground), ("disabledBackground", disabledBackground)]
            + avatarPalette.enumerated().map { ("avatarPalette[\($0.offset)]", $0.element) }
        }
    }
}

// MARK: Espacements, radius, icônes, composants, typographie

extension ThemeConfiguration {
    /// Valeurs de base (densité « normale »).
    struct Spacing: Codable, Equatable {
        var xxs: CGFloat = 2
        var xs: CGFloat = 4
        var sm: CGFloat = 8
        var md: CGFloat = 12
        var lg: CGFloat = 16
        var xl: CGFloat = 24
        var xxl: CGFloat = 32
        static let `default` = Spacing()
    }

    struct Radius: Codable, Equatable {
        var small: CGFloat = 6
        var medium: CGFloat = 10
        var large: CGFloat = 16
        var extraLarge: CGFloat = 24
        var messageBubble: CGFloat = 14
        var card: CGFloat = 16
        var button: CGFloat = 24
        static let `default` = Radius()

        /// Presets utilisés par l'écran Apparence.
        static let sharp = Radius(small: 2, medium: 4, large: 6, extraLarge: 8,
                                  messageBubble: 4, card: 6, button: 6)
        static let rounded = Radius(small: 10, medium: 16, large: 24, extraLarge: 32,
                                    messageBubble: 20, card: 24, button: 32)
    }

    /// Taille VISUELLE des icônes et taille de leur zone TACTILE (distinctes).
    struct IconMetrics: Codable, Equatable {
        var small: CGFloat = 16
        var medium: CGFloat = 22
        var large: CGFloat = 28
        var extraLarge: CGFloat = 40
        var touchCompact: CGFloat = 40
        var touchRegular: CGFloat = 44
        var touchLarge: CGFloat = 52
        static let `default` = IconMetrics()
    }

    struct ComponentStyles: Codable, Equatable {
        var cardStyle: CardStyle = .flat
        var buttonStyle: ButtonStyleKind = .filled
        var buttonMinHeight: CGFloat = 50
        var avatarSmall: CGFloat = 36
        var avatarMedium: CGFloat = 52
        var avatarLarge: CGFloat = 72
        static let `default` = ComponentStyles()
    }

    struct Typography: Codable, Equatable {
        var design: FontDesign = .standard
        static let `default` = Typography()
    }
}

// MARK: - Couleurs hexadécimales

enum HexColor {
    static func components(_ hex: String) -> (r: Double, g: Double, b: Double, a: Double)? {
        var s = hex.trimmingCharacters(in: .whitespaces)
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 6 || s.count == 8, let v = UInt64(s, radix: 16) else { return nil }
        if s.count == 6 {
            return (Double((v >> 16) & 0xFF) / 255, Double((v >> 8) & 0xFF) / 255,
                    Double(v & 0xFF) / 255, 1)
        }
        return (Double((v >> 24) & 0xFF) / 255, Double((v >> 16) & 0xFF) / 255,
                Double((v >> 8) & 0xFF) / 255, Double(v & 0xFF) / 255)
    }

    static func uiColor(_ hex: String) -> UIColor {
        guard let c = components(hex) else { return .magenta }   // visible si invalide
        return UIColor(red: c.r, green: c.g, blue: c.b, alpha: c.a)
    }

    /// Luminance relative WCAG.
    static func luminance(_ hex: String) -> Double? {
        guard let c = components(hex) else { return nil }
        func f(_ v: Double) -> Double { v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4) }
        return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b)
    }

    static func contrast(_ a: String, _ b: String) -> Double? {
        guard let la = luminance(a), let lb = luminance(b) else { return nil }
        return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)
    }
}

extension ThemeConfiguration.ColorPair {
    /// Couleur dynamique : suit automatiquement le Light/Dark Mode.
    var color: Color {
        let light = HexColor.uiColor(light), dark = HexColor.uiColor(dark)
        return Color(UIColor { $0.userInterfaceStyle == .dark ? dark : light })
    }
}

// MARK: - Presets d'accent (contrastes vérifiés ≥ 4.5 avec textOnAccent)

extension ThemeConfiguration {
    struct AccentPreset: Identifiable {
        let name: String
        let accent: ColorPair
        let selectedBackground: ColorPair
        var id: String { name }

        static let all: [AccentPreset] = [
            AccentPreset(name: "Vert", accent: ColorPair("#00765F", "#25D366"), selectedBackground: ColorPair("#E3F3EE", "#1B3A36")),
            AccentPreset(name: "Bleu", accent: ColorPair("#1A5FD0", "#5AA2FF"), selectedBackground: ColorPair("#E4EDFB", "#1B2D47")),
            AccentPreset(name: "Violet", accent: ColorPair("#6C3FC4", "#B093FF"), selectedBackground: ColorPair("#EFE9FA", "#2B2142")),
            AccentPreset(name: "Orange", accent: ColorPair("#B04A00", "#FF9A4D"), selectedBackground: ColorPair("#FBEBDD", "#42291A")),
            AccentPreset(name: "Rose", accent: ColorPair("#C2185B", "#FF7DB0"), selectedBackground: ColorPair("#FAE4EE", "#43202F"))
        ]
    }

    mutating func apply(_ preset: AccentPreset) {
        colors.accent = preset.accent
        colors.buttonBackground = preset.accent
        colors.selectedBackground = preset.selectedBackground
    }
}
