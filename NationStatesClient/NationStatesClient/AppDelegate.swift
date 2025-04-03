//
//  AppDelegate.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let deeplinkHandler: DeeplinkHandler = .init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        CensusScalesLoader.shared.load()
        
        // SwiftUI (still) doesn't color Alert content properly to accentColor. Alright, let me help them along..
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NotificationCenter
            .default
            .post(name: .notificationsDeviceTokenDidChange, object: self, userInfo: ["token": tokenString])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let urlString = response.notification.request.content.userInfo["url"] as? String, let url = URL(string: urlString) {
            deeplinkHandler.handle(url: url)
        }
        completionHandler()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            // Show banner, play sound, and set badge even if the app is open
            completionHandler([.banner, .sound, .badge])
    }
}

extension Notification.Name {
    static let notificationsDeviceTokenDidChange: Self = .init("notificationsDeviceTokenDidChange")
}
