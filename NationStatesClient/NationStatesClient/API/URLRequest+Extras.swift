//
//  URLRequest+Extras.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/10/2020.
//

import Foundation

extension URLRequest {
    mutating func setupUserAgentHeader(nationName: String?) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        let userAgent = "Issues-iOS-v\(appVersion ?? "-1")-\(nationName ?? "NO_NATION")"
        self.addValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
    
    mutating func setupPasswordAuthenticationHeader(_ password: String) {
        self.addValue(password, forHTTPHeaderField: AuthenticationMode.password.header)
    }
    
    mutating func setupAuthenticationHeaders(pair: AuthenticationPair) {
        if let autologin = pair.autologin {
            self.addValue(autologin, forHTTPHeaderField: AuthenticationMode.autologin.header)
        }
        if let pin = pair.pin {
            self.addValue(pin, forHTTPHeaderField: AuthenticationMode.pin.header)
        }
    }
}
