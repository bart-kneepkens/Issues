//
//  MoreBadgeViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/02/2025.
//

import Foundation

final class MoreBadgeViewModel: ObservableObject {
    
    @Published
    var badgeValue: String?
    
    private let notificationsProvider: NotificationsProvider
    private let userDefaults: UserDefaults
    private let isEnrolledForNotifications: Bool
    
    init(
        notificationsProvider: NotificationsProvider,
        authenticationContainer: AuthenticationContainer,
        userDefaults: UserDefaults = .standard
    ) {
        self.notificationsProvider = notificationsProvider
        self.userDefaults = userDefaults
        
        self.isEnrolledForNotifications = NotificationEnrolledNations.names.contains(authenticationContainer.nationName.lowercased())
        
#if DEBUG
        userDefaults.removeObject(forKey: Constants.didTapMoreBadgeAppVersionsKey)
#endif
      
        Task {
            await setup()
        }
    }
    
    func setup() async {
        let serverIsReachable = await notificationsProvider.isReachable
        
        var hasPreviouslyShownBadge: Bool {
            guard let appVersion = Constants.appVersion else { return false }
            let persistentAppVersions = userDefaults.array(forKey: Constants.didTapMoreBadgeAppVersionsKey) as? [String] ?? []
            return persistentAppVersions.contains(appVersion)
        }
        
        
        if serverIsReachable, isEnrolledForNotifications, !hasPreviouslyShownBadge {
            await MainActor.run {
                badgeValue = "•"
            }
        }
    }
    
    func clearBadge() {
        Task {
            await MainActor.run {
                badgeValue = nil
            }
        }
        guard let appVersion = Constants.appVersion else { return }
        var persistentAppVersions = userDefaults.array(forKey: Constants.didTapMoreBadgeAppVersionsKey) as? [String] ?? []
        persistentAppVersions.append(appVersion)
        userDefaults.setValue(persistentAppVersions, forKey: Constants.didTapMoreBadgeAppVersionsKey)
    }
}

private enum Constants {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let didTapMoreBadgeAppVersionsKey = "didTapMoreBadgeKey-versions"
}
