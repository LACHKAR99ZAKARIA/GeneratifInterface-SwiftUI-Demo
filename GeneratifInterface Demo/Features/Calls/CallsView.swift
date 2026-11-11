import SwiftUI

struct CallsView: View {
    @Environment(ChatStore.self) private var store

    var body: some View {
        NavigationStack {
            AppScreen {
                List {
                    Section {
                        ForEach(store.calls) { CallRow(call: $0) }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(AppColors.separator)
                    } header: {
                        AppSectionHeader(title: "Récents")
                            .textCase(nil)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Appels")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AppIconButton(icon: AppIcons.audioCall, accessibilityLabel: "Nouvel appel") {}
                }
            }
        }
    }
}

private struct CallRow: View {
    let call: CallRecord

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            AppAvatar(name: call.contact.name)
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(call.contact.name)
                    .font(AppTypography.headline)
                    .foregroundStyle(isMissed ? AppColors.textDestructive : AppColors.textPrimary)
                HStack(spacing: AppSpacing.xs) {
                    AppIcon(name: directionIcon, size: .small,
                            color: isMissed ? AppColors.textDestructive : AppColors.iconSecondary)
                    Text(ChatDateFormatter.listLabel(for: call.date))
                        .font(AppTypography.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            Spacer()
            AppIconButton(icon: call.kind == .video ? AppIcons.videoCall : AppIcons.audioCall,
                          accessibilityLabel: call.kind == .video ? "Rappeler en vidéo" : "Rappeler",
                          color: AppColors.accent) {}
        }
        .padding(.vertical, AppSpacing.xs)
        .accessibilityElement(children: .combine)
    }

    private var isMissed: Bool { call.direction == .missed }
    private var directionIcon: String {
        switch call.direction {
        case .incoming: AppIcons.callIncoming
        case .outgoing: AppIcons.callOutgoing
        case .missed: AppIcons.callMissed
        }
    }
}

#Preview("Appels") { CallsView().environment(ChatStore()) }
