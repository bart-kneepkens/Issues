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
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
#if DEBUG
        userDefaults.removeObject(forKey: Constants.didTapMoreBadgeAppVersionsKey)
#endif
        guard let persistentAppVersions = userDefaults.array(forKey: Constants.didTapMoreBadgeAppVersionsKey) as? [String],
              let appVersion = Constants.appVersion,
              persistentAppVersions.contains(appVersion) else {
            badgeValue = "•"
            return
        }
    }
    
    func clearBadge() {
        badgeValue = nil
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
