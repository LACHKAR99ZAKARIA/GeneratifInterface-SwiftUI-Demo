import SwiftUI
import Observation

// MARK: - Validation

enum ThemeValidationError: LocalizedError, Equatable {
    case invalidHex(name: String, value: String)
    case lowContrast(pair: String, ratio: Double, minimum: Double)
    case unsupportedSchema(Int)

    var errorDescription: String? {
        switch self {
        case let .invalidHex(name, value): "Couleur invalide « \(value) » pour \(name)."
        case let .lowContrast(pair, r, m):
            "Contraste insuffisant pour \(pair) : \(String(format: "%.1f", r)) (minimum \(m))."
        case let .unsupportedSchema(v): "Version de thème non supportée : \(v)."
        }
    }
}

extension ThemeConfiguration {
    /// Paires (texte, fond) dont le contraste est contrôlé, en Light ET Dark.
    private static let contrastRules: [(fg: KeyPath<Colors, ColorPair>, bg: KeyPath<Colors, ColorPair>,
                                        label: String, minimum: Double)] = [
        (\.textPrimary, \.background, "textPrimary/background", 4.5),
        (\.textPrimary, \.cardBackground, "textPrimary/cardBackground", 4.5),
        (\.textSecondary, \.background, "textSecondary/background", 4.5),
        (\.textOnAccent, \.accent, "textOnAccent/accent", 4.5),
        (\.textOnAccent, \.buttonBackground, "textOnAccent/buttonBackground", 4.5),
        (\.bubbleIncomingText, \.bubbleIncoming, "bubbleIncomingText/bubbleIncoming", 4.5),
        (\.bubbleOutgoingText, \.bubbleOutgoing, "bubbleOutgoingText/bubbleOutgoing", 4.5),
        (\.textPrimary, \.chatBackground, "textPrimary/chatBackground", 4.5)
    ]

    /// Retourne une configuration sûre : valeurs numériques bornées,
    /// couleurs hexadécimales valides et lisibles. Lève une erreur sinon.
    func validated() throws -> ThemeConfiguration {
        guard schemaVersion == 1 else { throw ThemeValidationError.unsupportedSchema(schemaVersion) }
        for (name, pair) in colors.named {
            for hex in [pair.light, pair.dark] where HexColor.components(hex) == nil {
                throw ThemeValidationError.invalidHex(name: name, value: hex)
            }
        }
        for rule in Self.contrastRules {
            let fg = colors[keyPath: rule.fg], bg = colors[keyPath: rule.bg]
            for (f, b) in [(fg.light, bg.light), (fg.dark, bg.dark)] {
                if let ratio = HexColor.contrast(f, b), ratio < rule.minimum {
                    throw ThemeValidationError.lowContrast(pair: rule.label, ratio: ratio, minimum: rule.minimum)
                }
            }
        }
        var c = self
        func clamp(_ v: CGFloat, _ r: ClosedRange<CGFloat>) -> CGFloat { min(max(v, r.lowerBound), r.upperBound) }
        c.spacing.xxs = clamp(spacing.xxs, 0...8);   c.spacing.xs = clamp(spacing.xs, 0...12)
        c.spacing.sm = clamp(spacing.sm, 2...20);    c.spacing.md = clamp(spacing.md, 4...28)
        c.spacing.lg = clamp(spacing.lg, 8...36);    c.spacing.xl = clamp(spacing.xl, 12...48)
        c.spacing.xxl = clamp(spacing.xxl, 16...64)
        c.radius.small = clamp(radius.small, 0...16);       c.radius.medium = clamp(radius.medium, 0...24)
        c.radius.large = clamp(radius.large, 0...32);       c.radius.extraLarge = clamp(radius.extraLarge, 0...48)
        c.radius.messageBubble = clamp(radius.messageBubble, 0...28)
        c.radius.card = clamp(radius.card, 0...36);         c.radius.button = clamp(radius.button, 0...40)
        c.icons.small = clamp(icons.small, 12...24);        c.icons.medium = clamp(icons.medium, 16...32)
        c.icons.large = clamp(icons.large, 20...40);        c.icons.extraLarge = clamp(icons.extraLarge, 28...64)
        // Accessibilité : zone tactile « regular » et « large » ≥ 44 pt.
        c.icons.touchCompact = clamp(icons.touchCompact, 32...56)
        c.icons.touchRegular = clamp(icons.touchRegular, 44...64)
        c.icons.touchLarge = clamp(icons.touchLarge, 44...72)
        c.components.buttonMinHeight = clamp(components.buttonMinHeight, 44...64)
        c.components.avatarSmall = clamp(components.avatarSmall, 24...48)
        c.components.avatarMedium = clamp(components.avatarMedium, 36...72)
        c.components.avatarLarge = clamp(components.avatarLarge, 48...112)
        return c
    }
}

// MARK: - Persistance

protocol ThemeStore {
    func load() -> ThemeConfiguration?
    func save(_ configuration: ThemeConfiguration)
    func clear()
}

struct UserDefaultsThemeStore: ThemeStore {
    var defaults: UserDefaults = .standard
    var key = "app.theme.configuration.v1"

    func load() -> ThemeConfiguration? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(ThemeConfiguration.self, from: data)
    }
    func save(_ configuration: ThemeConfiguration) {
        if let data = try? JSONEncoder().encode(configuration) { defaults.set(data, forKey: key) }
    }
    func clear() { defaults.removeObject(forKey: key) }
}

// MARK: - ThemeManager

/// Point d'entrée unique pour changer le thème à l'exécution.
/// `@Observable` : toute vue qui lit un token (`AppColors.accent`, `AppSpacing.md`…)
/// dans son `body` est automatiquement ré-évaluée quand la configuration change.
@Observable
final class ThemeManager {
    static let shared = ThemeManager()

    private(set) var configuration: ThemeConfiguration
    private let store: ThemeStore

    init(store: ThemeStore = UserDefaultsThemeStore()) {
        self.store = store
        // Restauration : une configuration persistée invalide est ignorée.
        if let saved = store.load(), let valid = try? saved.validated() {
            configuration = valid
        } else {
            configuration = .default
        }
    }

    /// Applique une configuration complète après validation, puis la persiste.
    func apply(_ newConfiguration: ThemeConfiguration, animated: Bool = true) throws {
        let valid = try newConfiguration.validated()
        if animated {
            withAnimation(.easeInOut(duration: 0.25)) { configuration = valid }
        } else {
            configuration = valid
        }
        store.save(valid)
    }

    /// Point d'entrée prévu pour une configuration générée par IA (JSON).
    func apply(jsonData: Data) throws {
        try apply(JSONDecoder().decode(ThemeConfiguration.self, from: jsonData))
    }

    /// Modification ciblée (utilisée par l'écran Apparence). Ignorée si invalide.
    func update(_ change: (inout ThemeConfiguration) -> Void) {
        var copy = configuration
        change(&copy)
        try? apply(copy)
    }

    func resetToDefault() {
        store.clear()
        withAnimation(.easeInOut(duration: 0.25)) { configuration = .default }
    }

    var isCustomized: Bool { configuration != .default }
}
