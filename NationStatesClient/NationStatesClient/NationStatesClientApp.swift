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
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: viewModelFactory.contentViewModel,
                moreBadgeViewModel: viewModelFactory.moreBadgeViewModel
            )
            .environmentObject(appDelegate.deeplinkHandler)
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    appDelegate.cleardBadgeAndNotifications()
                }
            }
        }
    }
}
