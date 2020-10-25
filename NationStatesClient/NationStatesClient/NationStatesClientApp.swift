//
//  NationStatesClientApp.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

@main
struct NationStatesClientApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
