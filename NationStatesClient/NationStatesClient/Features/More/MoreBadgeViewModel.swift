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
    
    @Published
    var showsNotificationFeatureInterestElements = false
    
    private let notificationFeatureInterestProvider: NotificationFeatureInterestProvider
    private let userDefaults: UserDefaults
    
    init(
        notificationFeatureInterestProvider: NotificationFeatureInterestProvider,
        userDefaults: UserDefaults = .standard
    ) {
        self.notificationFeatureInterestProvider = notificationFeatureInterestProvider
        self.userDefaults = userDefaults
        
#if DEBUG
        userDefaults.removeObject(forKey: Constants.didTapMoreBadgeAppVersionsKey)
#endif
        
    }
    
    func setup() async {
        let serverIsReachable = await notificationFeatureInterestProvider.isReachable
        
        if serverIsReachable {
            await MainActor.run {
                showsNotificationFeatureInterestElements = true
            }
        }
        
        var hasPreviouslyShownBadge: Bool {
            guard let appVersion = Constants.appVersion else { return false }
            let persistentAppVersions = userDefaults.array(forKey: Constants.didTapMoreBadgeAppVersionsKey) as? [String] ?? []
            return persistentAppVersions.contains(appVersion)
        }
        
        
        if serverIsReachable, !hasPreviouslyShownBadge {
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
