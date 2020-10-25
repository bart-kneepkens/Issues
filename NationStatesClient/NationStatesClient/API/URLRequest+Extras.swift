//
//  URLRequest+Extras.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/10/2020.
//

import Foundation

extension URLRequest {
    mutating func setupUserAgentHeader() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let nationName = Authentication.shared.nationName
        
        let userAgent = "Issues-iOS-v\(appVersion ?? "-1")-\(nationName ?? "NO_NATION")"
        self.addValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
    
    mutating func setupPasswordAuthenticationHeader(_ password: String) {
        self.addValue(password, forHTTPHeaderField: AuthenticationMode.password.header)
    }
    
    mutating func setupAuthenticationHeaders() {
        if let autologin = Authentication.shared.autoLogin {
            self.addValue(autologin, forHTTPHeaderField: AuthenticationMode.autologin.header)
        }
        if let pin = Authentication.shared.pin {
            self.addValue(pin, forHTTPHeaderField: AuthenticationMode.pin.header)
        }
    }
}
