//
//  APINotificationsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/03/2025.
//

import Foundation

final class APINotificationsProvider: NotificationsProvider {

    private let api = NotificationsAPI()
    private let authenticationContainer: AuthenticationContainer
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
    }
    
    var isReachable:  Bool {
        get async {
            await api.isReachable
        }
    }
    
    func register(deviceToken: String) async -> Bool {
        let nationName = authenticationContainer.nationName.lowercased()
        let pin = authenticationContainer.pin
        let autologin = authenticationContainer.autologin
        guard let pin, let autologin else { return false }
        
        return await api.register(nationName: nationName, pin: pin, autologin: autologin, deviceToken: deviceToken)
    }
    
    func unregister() async -> Bool {
        let nationName = authenticationContainer.nationName.lowercased()
        return await api.unregister(nationName: nationName)
    }
}
