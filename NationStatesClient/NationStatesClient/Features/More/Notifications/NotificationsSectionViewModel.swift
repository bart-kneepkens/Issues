//
//  NotificationsSectionViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 28/03/2025.
//

import Foundation
import UserNotifications
import UIKit
import Combine

class NotificationsSectionViewModel: ObservableObject {
    
    @Published var serverIsReachable: Bool?
    @Published var notificationsEnabled: Bool {
        didSet {
            if oldValue == false, notificationsEnabled == true {
                Task {
                    await requestAuthorizationAndRegisterLocally()
                }
            } else if oldValue == true, notificationsEnabled == false {
                Task {
                    await unregister()
                }
            }
        }
    }
    
    private let notificationsProvider: NotificationsProvider
    private let notificationCenter = UNUserNotificationCenter.current()
    private var tokenCancellable: AnyCancellable?
    private let userDefaults = UserDefaults.standard

    init(notificationsProvider: NotificationsProvider) {
        self.notificationsProvider = notificationsProvider
        self.notificationsEnabled = userDefaults.bool(forKey: "notifications-enabled")
        
        NotificationCenter.default.addObserver(
            forName: .notificationsDeviceTokenDidChange,
            object: nil,
            queue: .main) { notification in
                guard let userInfo = notification.userInfo, let token = userInfo["token"] as? String else { return }
                Task {
                    await self.registerWithNotificationsService(token: token)
                }
            }
    }
    
    func fetchServerStatus() async {
        let isReachable = await notificationsProvider.isReachable
        
        await MainActor.run {
            serverIsReachable = isReachable
        }
    }
    
    private func requestAuthorizationAndRegisterLocally() async {
        guard let authorization = try? await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) else {
            // Alert
            return
        }
        
        await UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func registerWithNotificationsService(token: String) async {
        let result = await notificationsProvider.register(deviceToken: token)
        
        if result == false {
            await MainActor.run {
                notificationsEnabled = false
            }
        }
        
        userDefaults.setValue(result, forKey: notificationsEnabledPersistenceKey)
    }
    
    private func unregister() async {
        await notificationsProvider.unregister()
    }
}

private let notificationsEnabledPersistenceKey = "notifications-enabled"
