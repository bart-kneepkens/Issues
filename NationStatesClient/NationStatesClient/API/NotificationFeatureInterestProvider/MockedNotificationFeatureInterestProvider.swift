//
//  MockedNotificationFeatureInterestProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/02/2025.
//

import Foundation

final class MockedNotificationFeatureInterestProvider: NotificationFeatureInterestProvider {
    
    var isReachable:  Bool {
        get async {
            true
        }
    }
    
    @discardableResult
    func enroll(nationName: String, pin: String) async -> Bool {
        true
    }
    
    @discardableResult
    func disEnroll(nationName: String, pin: String) async -> Bool{
        true
    }
}
