//
//  APINotificationFeatureInterestProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/02/2025.
//

import Foundation

final class APINotificationFeatureInterestProvider: NotificationFeatureInterestProvider {
    private let api = ExperimentsAPI()
    
    var isReachable:  Bool {
        get async {
            await api.isReachable
        }
    }
    
    func enroll(nationName: String, pin: String) async -> Bool {
        await api.enroll(nationName: nationName, pin: pin)
    }
    
    func disEnroll(nationName: String, pin: String) async -> Bool{
        await api.undo(nationName: nationName, pin: pin)
    }
}
