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
    
    func enroll(deviceToken: String) async -> Bool {
        true
    }
    
    func disEnroll() async -> Bool {
        true
    }
}
#endif
