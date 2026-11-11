import SwiftUI

struct UpdatesView: View {
    @Environment(ChatStore.self) private var store
    @State private var followed: Set<Channel.ID> = []

    var body: some View {
        NavigationStack {
            AppScreen {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.sectionGap) {
                        statusSection
                        channelsSection
                    }
                    .padding(.vertical, AppSpacing.lg)
                }
            }
            .navigationTitle("Actus")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AppIconButton(icon: AppIcons.camera, accessibilityLabel: "Nouveau statut") {}
                }
            }
        }
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            AppSectionHeader(title: "Statuts").padding(.horizontal, AppSpacing.screenHorizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    myStatusCard
                    ForEach(store.statuses) { StatusCard(status: $0) }
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
            }
        }
    }

    private var myStatusCard: some View {
        AppCard {
            VStack(spacing: AppSpacing.sm) {
                AppIcon(name: AppIcons.add, size: .large, color: AppColors.accent, weight: .semibold)
                    .frame(width: AppAvatarSize.medium.points, height: AppAvatarSize.medium.points)
                    .background(AppColors.selectedBackground, in: Circle())
                Text("Mon statut").font(AppTypography.subheadline.weight(.semibold)).foregroundStyle(AppColors.textPrimary)
                Text("Ajouter").font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
            }
            .frame(width: AppAvatarSize.large.points)
        }
        .fixedSize()
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }

    private var channelsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            AppSectionHeader(title: "Chaînes à découvrir")
            ForEach(store.channels) { channel in
                AppCard {
                    HStack(spacing: AppSpacing.md) {
                        AppIcon(name: AppIcons.channel, size: .large, color: AppColors.textOnAccent)
                            .frame(width: AppAvatarSize.medium.points, height: AppAvatarSize.medium.points)
                            .background(AppColors.avatar(for: channel.name), in: Circle())
                        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                            Text(channel.name).font(AppTypography.headline).foregroundStyle(AppColors.textPrimary)
                            Text(channel.summary).font(AppTypography.subheadline).foregroundStyle(AppColors.textSecondary)
                            Text(channel.followers).font(AppTypography.caption).foregroundStyle(AppColors.textSecondary)
                        }
                        Spacer(minLength: AppSpacing.sm)
                        followButton(for: channel)
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }

    private func followButton(for channel: Channel) -> some View {
        let isFollowing = followed.contains(channel.id)
        return Button(isFollowing ? "Suivie" : "Suivre") {
            withAnimation(.easeOut(duration: 0.15)) {
                if isFollowing { followed.remove(channel.id) } else { followed.insert(channel.id) }
            }
        }
        .font(AppTypography.subheadline.weight(.semibold))
        .foregroundStyle(isFollowing ? AppColors.textSecondary : AppColors.textOnAccent)
        .padding(.horizontal, AppSpacing.md)
        .frame(minHeight: AppIconSize.touchRegular)
        .background(isFollowing ? AppColors.backgroundSecondary : AppColors.buttonBackground,
                    in: RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous))
        .buttonStyle(AppPressStyle())
    }
}

private struct StatusCard: View {
    let status: StatusUpdate

    var body: some View {
        AppCard {
            VStack(spacing: AppSpacing.sm) {
                AppAvatar(name: status.contact.name, size: .medium, ring: status.isSeen ? .seen : .unseen)
                    .padding(AppSpacing.xs)
                Text(status.contact.name.split(separator: " ").first.map(String.init) ?? status.contact.name)
                    .font(AppTypography.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                Text(ChatDateFormatter.listLabel(for: status.date))
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(width: AppAvatarSize.large.points)
        }
        .fixedSize()
        .accessibilityElement(children: .combine)
        .accessibilityHint(status.caption)
    }
}

#Preview("Actus") { UpdatesView().environment(ChatStore()) }
