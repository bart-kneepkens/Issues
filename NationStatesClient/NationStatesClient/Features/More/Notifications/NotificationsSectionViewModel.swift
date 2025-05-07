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
    
    enum State {
        case initial
        case denied
        case granted
        case active
        case inactive
    }
    
    @Published var state: State = .initial
    @Published var serverIsReachable: Bool?
    
    private let notificationsProvider: NotificationsProvider
    private let notificationCenter = UNUserNotificationCenter.current()
    private let userDefaults = UserDefaults.standard
    

    init(notificationsProvider: NotificationsProvider) {
        self.notificationsProvider = notificationsProvider
        
        Task {
            let authorizationStatus = await notificationCenter.notificationSettings().authorizationStatus
            switch authorizationStatus {
            case .notDetermined: break
            case .denied:
                self.state = .denied
            case .authorized, .provisional, .ephemeral:
                if userDefaults.bool(forKey: notificationsActivePersistenceKey) == true {
                    await updateState(to: .active)
                } else {
                    await updateState(to: .inactive)
                }
            @unknown default:
                break
            }
            
        }
        
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
    
    @MainActor
    func didTap() async {
        switch state {
        case .initial:
            await requestAuthorizationAndRegisterLocally()
        case .denied:
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                await UIApplication.shared.open(url)
            }
        default:
            break
        }
    }
    
    func toggleWasUpdated(newValue: Bool) async {
        if newValue {
            await requestAuthorizationAndRegisterLocally()
        } else {
            await unregister()
        }
    }
    
    func fetchServerStatus() async {
        let isReachable = await notificationsProvider.isReachable
        
        await MainActor.run {
            serverIsReachable = isReachable
        }
    }
    
    private func requestAuthorizationAndRegisterLocally() async {
        let hasAuthorizationForNotifications = try? await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
        guard hasAuthorizationForNotifications == true else {
            await updateState(to: .denied)
            return
        }
        
        await updateState(to: .granted)
        
        await UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func registerWithNotificationsService(token: String) async {
        let result = await notificationsProvider.register(deviceToken: token)
        
        if result == false {
            await updateState(to: .inactive)
        } else {
            await updateState(to: .active)
        }
    }
    
    private func unregister() async {
        await notificationsProvider.unregister()
        await updateState(to: .inactive)
    }
    
    @MainActor private func updateState(to newState: State) {
        self.state = newState
    }
}

private let notificationsActivePersistenceKey = "notifications-active"
