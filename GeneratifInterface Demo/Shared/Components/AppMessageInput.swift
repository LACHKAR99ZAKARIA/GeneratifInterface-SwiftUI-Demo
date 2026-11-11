import SwiftUI

/// Barre de saisie : pièce jointe, champ multiligne, caméra, envoi / micro.
struct AppMessageInput: View {
    @Binding var text: String
    var onSend: () -> Void
    var onAttach: () -> Void = {}
    var onCamera: () -> Void = {}
    var onMicrophone: () -> Void = {}

    private var canSend: Bool { !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        HStack(alignment: .bottom, spacing: AppSpacing.xs) {
            AppIconButton(icon: AppIcons.attachment, accessibilityLabel: "Joindre un fichier",
                          size: .large, action: onAttach)
            HStack(alignment: .bottom, spacing: 0) {
                TextField("Message", text: $text, axis: .vertical)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1...5)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                if !canSend {
                    AppIconButton(icon: AppIcons.camera, accessibilityLabel: "Caméra",
                                  touch: .compact, action: onCamera)
                        .transition(.opacity)
                }
            }
            .frame(minHeight: AppIconSize.touchRegular)
            .background(AppColors.backgroundSecondary,
                        in: RoundedRectangle(cornerRadius: AppRadius.extraLarge, style: .continuous))
            sendOrMic
        }
        .padding(.horizontal, AppSpacing.inputPadding)
        .padding(.vertical, AppSpacing.xs)
        .background(AppColors.background)
        .animation(.easeOut(duration: 0.15), value: canSend)
    }

    @ViewBuilder
    private var sendOrMic: some View {
        if canSend {
            Button(action: onSend) {
                AppIcon(name: AppIcons.send, size: .medium, color: AppColors.textOnAccent, weight: .bold)
                    .frame(width: AppIconSize.touchRegular, height: AppIconSize.touchRegular)
                    .background(AppColors.buttonBackground, in: Circle())
                    .contentShape(Circle())
            }
            .buttonStyle(AppPressStyle())
            .accessibilityLabel("Envoyer")
        } else {
            AppIconButton(icon: AppIcons.microphone, accessibilityLabel: "Message vocal",
                          size: .large, action: onMicrophone)
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    return VStack { Spacer(); AppMessageInput(text: $text) {} }
}
