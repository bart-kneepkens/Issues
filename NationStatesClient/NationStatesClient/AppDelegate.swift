//
//  AppDelegate.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        CensusScalesLoader.shared.load()
        
        // SwiftUI (still) doesn't color Alert content properly to accentColor. Alright, let me help them along..
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NotificationCenter
            .default
            .post(name: .notificationsDeviceTokenDidChange, object: self, userInfo: ["token": tokenString])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}

extension Notification.Name {
    static let notificationsDeviceTokenDidChange: Self = .init("notificationsDeviceTokenDidChange")
}
