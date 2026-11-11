import SwiftUI

/// Thème propre à une conversation : fond + bulles + textes.
/// Remplace localement les tokens globaux (`AppColors.chatBackground`, bulles…)
/// via l'environnement. Contrastes texte/bulle ≥ 7 en clair et en sombre.
struct ConversationStyle: Identifiable, Equatable {
    typealias Pair = ThemeConfiguration.ColorPair

    let id: String
    let name: String
    let background: Pair
    let incomingBubble: Pair
    let outgoingBubble: Pair
    let incomingText: Pair
    let outgoingText: Pair

    static let all: [ConversationStyle] = [
        ConversationStyle(id: "ocean", name: "Océan",
                          background: Pair("#DCEBF5", "#0A1A26"),
                          incomingBubble: Pair("#FFFFFF", "#16293A"), outgoingBubble: Pair("#BFE0F7", "#0F4C75"),
                          incomingText: Pair("#0B1F2E", "#E6F1F8"), outgoingText: Pair("#0B1F2E", "#E6F1F8")),
        ConversationStyle(id: "foret", name: "Forêt",
                          background: Pair("#E1EBDD", "#0E1A12"),
                          incomingBubble: Pair("#FFFFFF", "#1A2B1F"), outgoingBubble: Pair("#C7E6B9", "#1F5A2E"),
                          incomingText: Pair("#10210F", "#E8F3E6"), outgoingText: Pair("#10210F", "#E8F3E6")),
        ConversationStyle(id: "coucher", name: "Coucher de soleil",
                          background: Pair("#F8E6D8", "#24140D"),
                          incomingBubble: Pair("#FFFFFF", "#35201A"), outgoingBubble: Pair("#FFD2A8", "#8A3B12"),
                          incomingText: Pair("#2A1608", "#FFF1E6"), outgoingText: Pair("#2A1608", "#FFF1E6")),
        ConversationStyle(id: "minuit", name: "Minuit",
                          background: Pair("#E7E7F1", "#05050D"),
                          incomingBubble: Pair("#FFFFFF", "#15152A"), outgoingBubble: Pair("#CFCFF5", "#3A3AA0"),
                          incomingText: Pair("#14142B", "#EDEDFB"), outgoingText: Pair("#14142B", "#EDEDFB"))
    ]

    static func preset(id: String?) -> ConversationStyle? { all.first { $0.id == id } }

    // MARK: Thème personnalisé (couleurs libres, identiques en clair et sombre)

    static let customID = "custom"

    struct Custom: Codable, Equatable {
        var background = "#EFEAE2"
        var incomingBubble = "#FFFFFF"
        var outgoingBubble = "#D9FDD3"
        var incomingText = "#111B21"
        var outgoingText = "#111B21"

        static let minimumContrast = 4.5

        var incomingContrast: Double { HexColor.contrast(incomingText, incomingBubble) ?? 0 }
        var outgoingContrast: Double { HexColor.contrast(outgoingText, outgoingBubble) ?? 0 }
        /// Texte lisible sur sa bulle (WCAG AA).
        var isReadable: Bool {
            incomingContrast >= Self.minimumContrast && outgoingContrast >= Self.minimumContrast
        }
    }

    static func custom(_ c: Custom) -> ConversationStyle {
        ConversationStyle(id: customID, name: "Personnalisé",
                          background: Pair(c.background, c.background),
                          incomingBubble: Pair(c.incomingBubble, c.incomingBubble),
                          outgoingBubble: Pair(c.outgoingBubble, c.outgoingBubble),
                          incomingText: Pair(c.incomingText, c.incomingText),
                          outgoingText: Pair(c.outgoingText, c.outgoingText))
    }
}

extension HexColor {
    /// `#RRGGBB` à partir d'une `Color` SwiftUI (sélecteur de couleur).
    static func hex(from color: Color) -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int((r * 255).rounded()), Int((g * 255).rounded()), Int((b * 255).rounded()))
    }
}

private struct ConversationStyleKey: EnvironmentKey {
    static let defaultValue: ConversationStyle? = nil
}

extension EnvironmentValues {
    /// `nil` = utiliser le thème global.
    var conversationStyle: ConversationStyle? {
        get { self[ConversationStyleKey.self] }
        set { self[ConversationStyleKey.self] = newValue }
    }
}
