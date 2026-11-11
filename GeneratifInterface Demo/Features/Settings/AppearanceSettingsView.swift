import SwiftUI

/// Écran de démonstration du ThemeManager : chaque contrôle modifie la
/// configuration globale et toute l'application se met à jour immédiatement.
struct AppearanceSettingsView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        AppScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.sectionGap) {
                    preview
                    section("Mode") { picker(\.appearance, ThemeConfiguration.Appearance.allCases, \.label) }
                    section("Couleur d'accent") { accentPicker }
                    section("Densité") { picker(\.density, ThemeConfiguration.Density.allCases, \.label) }
                    section("Coins") { cornerPicker }
                    section("Style des cartes") { picker(\.components.cardStyle, ThemeConfiguration.CardStyle.allCases, \.label) }
                    section("Police") {
                        picker(\.typography.design, ThemeConfiguration.FontDesign.allCases) { $0.rawValue.capitalized }
                    }
                    AppPrimaryButton(title: "Rétablir le thème par défaut", icon: AppIcons.reset) {
                        theme.resetToDefault()
                    }
                    .disabled(!theme.isCustomized)
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
        }
        .navigationTitle("Apparence")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Aperçu

    private var preview: some View {
        VStack(spacing: AppSpacing.messageGap) {
            AppMessageBubble(message: Message(text: "Que penses-tu de ce thème ?", date: .now, isOutgoing: false))
            AppMessageBubble(message: Message(text: "Il change en direct 🎨", date: .now, isOutgoing: true, status: .read))
        }
        .padding(AppSpacing.lg)
        .background(AppColors.chatBackground, in: RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
    }

    // MARK: Contrôles

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            AppSectionHeader(title: title)
            content()
        }
    }

    private func picker<V: Hashable>(_ keyPath: WritableKeyPath<ThemeConfiguration, V>, _ values: [V],
                                     _ label: @escaping (V) -> String) -> some View {
        Picker("", selection: Binding(get: { theme.configuration[keyPath: keyPath] },
                                      set: { value in theme.update { $0[keyPath: keyPath] = value } })) {
            ForEach(values, id: \.self) { Text(label($0)).tag($0) }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }

    private func picker<V: Hashable>(_ keyPath: WritableKeyPath<ThemeConfiguration, V>, _ values: [V],
                                     _ label: KeyPath<V, String>) -> some View {
        picker(keyPath, values) { $0[keyPath: label] }
    }

    private var accentPicker: some View {
        HStack(spacing: AppSpacing.md) {
            ForEach(ThemeConfiguration.AccentPreset.all) { preset in
                let isSelected = theme.configuration.colors.accent == preset.accent
                Button { theme.update { $0.apply(preset) } } label: {
                    Circle()
                        .fill(preset.accent.color)
                        .frame(width: AppIconSize.extraLarge, height: AppIconSize.extraLarge)
                        .overlay {
                            if isSelected {
                                AppIcon(name: AppIcons.checkmark, size: .medium, color: AppColors.textOnAccent, weight: .bold)
                            }
                        }
                        .frame(width: AppIconSize.touchLarge, height: AppIconSize.touchLarge)
                        .contentShape(Rectangle())
                }
                .buttonStyle(AppPressStyle())
                .accessibilityLabel(preset.name)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
    }

    private enum Corners: String, CaseIterable {
        case sharp = "Nets", standard = "Standard", rounded = "Arrondis"
        var radius: ThemeConfiguration.Radius {
            switch self {
            case .sharp: .sharp
            case .standard: .default
            case .rounded: .rounded
            }
        }
    }

    private var cornerPicker: some View {
        let current = Corners.allCases.first { $0.radius == theme.configuration.radius } ?? .standard
        return Picker("", selection: Binding(get: { current }, set: { c in theme.update { $0.radius = c.radius } })) {
            ForEach(Corners.allCases, id: \.self) { Text($0.rawValue).tag($0) }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }
}

#Preview("Apparence") {
    NavigationStack { AppearanceSettingsView() }.environment(ThemeManager.shared)
}
