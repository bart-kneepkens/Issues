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
}
