import SwiftUI

/// Symbole SF avec taille VISUELLE issue du Design System (suit Dynamic Type).
struct AppIcon: View {
    let name: String
    var size: AppIconSize.Size = .medium
    var color: Color?
    var weight: Font.Weight = .regular

    var body: some View {
        Image(systemName: name)
            .font(.system(size: size.points, weight: weight))
            .imageScale(.medium)
            .foregroundStyle(color ?? AppColors.iconPrimary)
            .accessibilityHidden(true)
    }
}

/// Bouton-icône : taille visuelle ≠ zone tactile (≥ 44 pt en `.regular`).
/// États : normal, pressed, selected, disabled.
struct AppIconButton: View {
    let icon: String
    let accessibilityLabel: String
    var size: AppIconSize.Size = .medium
    var touch: AppIconSize.Touch = .regular
    var isSelected = false
    var color: Color?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            AppIconContent(icon: icon, size: size, touch: touch, isSelected: isSelected, color: color)
        }
        .buttonStyle(AppPressStyle())
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct AppIconContent: View {
    @Environment(\.isEnabled) private var isEnabled
    let icon: String
    let size: AppIconSize.Size
    let touch: AppIconSize.Touch
    let isSelected: Bool
    let color: Color?

    var body: some View {
        AppIcon(name: icon, size: size, color: tint)
            .frame(width: touch.points, height: touch.points)
            .background(isSelected ? AppColors.selectedBackground : .clear, in: Circle())
            .contentShape(Rectangle())
    }

    private var tint: Color {
        if !isEnabled { return AppColors.disabledForeground }
        if isSelected { return AppColors.accent }
        return color ?? AppColors.iconPrimary
    }
}

/// Retour visuel léger à l'appui, partagé par les boutons.
struct AppPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.55 : 1)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

#Preview {
    HStack {
        AppIconButton(icon: AppIcons.search, accessibilityLabel: "Rechercher") {}
        AppIconButton(icon: AppIcons.camera, accessibilityLabel: "Caméra", isSelected: true) {}
        AppIconButton(icon: AppIcons.microphone, accessibilityLabel: "Micro") {}.disabled(true)
    }
    .padding()
}
