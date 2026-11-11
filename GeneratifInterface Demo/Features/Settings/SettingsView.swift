import SwiftUI

struct SettingsView: View {
    @State private var comingSoon: String?
    @AppStorage("settings.messagePreviews") private var messagePreviews = true

    var body: some View {
        NavigationStack {
            AppScreen {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.sectionGap) {
                        profileCard
                        group("Compte") {
                            placeholderRow(AppIcons.account, "Compte")
                            placeholderRow(AppIcons.privacy, "Confidentialité")
                            placeholderRow(AppIcons.chatsSettings, "Discussions", divider: false)
                        }
                        group("Préférences") {
                            NavigationLink { AppearanceSettingsView() } label: {
                                SettingsRow(icon: AppIcons.appearance, title: "Apparence", detail: "Thème, couleurs, densité")
                            }
                            .buttonStyle(.plain)
                            AppDivider(leadingInset: SettingsRow<EmptyView>.dividerInset)
                            SettingsRow(icon: AppIcons.notifications, title: "Aperçu des messages") {
                                Toggle("Aperçu des messages", isOn: $messagePreviews)
                                    .labelsHidden()
                                    .tint(AppColors.accent)
                            }
                            AppDivider(leadingInset: SettingsRow<EmptyView>.dividerInset)
                            placeholderRow(AppIcons.storage, "Stockage et données", divider: false)
                        }
                        group("Assistance") {
                            placeholderRow(AppIcons.help, "Aide")
                            placeholderRow(AppIcons.invite, "Inviter un ami", divider: false)
                        }
                    }
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                    .padding(.vertical, AppSpacing.lg)
                }
            }
            .navigationTitle("Réglages")
            .alert("Bientôt disponible", isPresented: Binding(get: { comingSoon != nil }, set: { if !$0 { comingSoon = nil } })) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("« \(comingSoon ?? "") » n'est pas encore implémenté dans cette première version.")
            }
        }
    }

    private var profileCard: some View {
        AppCard {
            HStack(spacing: AppSpacing.md) {
                AppAvatar(name: "Zakaria Lachkar", size: .large)
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("Zakaria Lachkar").font(AppTypography.title).foregroundStyle(AppColors.textPrimary)
                    Text("Disponible").font(AppTypography.subheadline).foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }

    private func group(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            AppSectionHeader(title: title)
            AppCard(padding: 0) { VStack(spacing: 0) { content() } }
        }
    }

    @ViewBuilder
    private func placeholderRow(_ icon: String, _ title: String, divider: Bool = true) -> some View {
        Button { comingSoon = title } label: { SettingsRow(icon: icon, title: title) }
            .buttonStyle(.plain)
        if divider { AppDivider(leadingInset: SettingsRow<EmptyView>.dividerInset) }
    }
}

/// Ligne de réglage réutilisable : icône, titre, détail, accessoire (chevron par défaut).
struct SettingsRow<Accessory: View>: View {
    let icon: String
    let title: String
    var detail: String?
    @ViewBuilder var accessory: Accessory

    /// Colonne d'icône fixe pour aligner titres et séparateurs.
    static var iconColumn: CGFloat { AppIconSize.large * 1.4 }
    static var dividerInset: CGFloat { AppSpacing.lg + iconColumn + AppSpacing.md }

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            AppIcon(name: icon, size: .large, color: AppColors.iconPrimary)
                .frame(width: Self.iconColumn)
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title).font(AppTypography.body).foregroundStyle(AppColors.textPrimary)
                if let detail {
                    Text(detail).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                }
            }
            Spacer(minLength: AppSpacing.sm)
            accessory
        }
        .padding(.horizontal, AppSpacing.lg)
        .frame(minHeight: AppIconSize.touchLarge)
        .contentShape(Rectangle())
    }
}

extension SettingsRow where Accessory == AnyView {
    init(icon: String, title: String, detail: String? = nil) {
        self.init(icon: icon, title: title, detail: detail) {
            AnyView(AppIcon(name: AppIcons.chevron, size: .small, color: AppColors.iconSecondary))
        }
    }
}

#Preview("Réglages") { SettingsView() }
