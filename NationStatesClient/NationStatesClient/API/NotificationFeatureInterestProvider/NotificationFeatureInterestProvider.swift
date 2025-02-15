//
//  NotificationFeatureInterestProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/02/2025.
//

import Foundation

protocol NotificationFeatureInterestProvider {
    var isReachable: Bool { get async }
    @discardableResult
    func enroll(nationName: String, pin: String) async -> Bool
    @discardableResult
    func disEnroll(nationName: String, pin: String) async -> Bool
}
