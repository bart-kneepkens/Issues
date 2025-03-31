//
//  NotificationsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/03/2025.
//

import Foundation

protocol NotificationsProvider {
    var isReachable: Bool { get async }
    @discardableResult
    func register(deviceToken: String) async -> Bool
    @discardableResult
    func unregister() async -> Bool
}

