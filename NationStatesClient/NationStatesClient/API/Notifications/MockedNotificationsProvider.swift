//
//  MockedNotificationsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/03/2025.
//

import Foundation

#if DEBUG
class MockedNotificationsProvider: NotificationsProvider {
    var isReachable: Bool { true }
    
    func register(deviceToken: String) async -> Bool {
        true
    }
    
    func unregister() async -> Bool {
        true
    }
}
#endif
