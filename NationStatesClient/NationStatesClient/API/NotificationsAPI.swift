//
//  NotificationsAPI.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/03/2025.
//

import Foundation

final class NotificationsAPI {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    var isReachable: Bool {
        get async {
            guard let url = URLBuilder.healthURL else { return false }
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            guard let response = try? await session.data(for: request).1 else { return false }
            return (response as? HTTPURLResponse)?.statusCode == 200
        }
    }
    
    func register(nationName: String, pin: String, autologin: String, deviceToken: String) async -> Bool {
        guard let url = URLBuilder.registerURL else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "nation": nationName,
            "pin": pin,
            "autologin": autologin,
            "device_token": deviceToken
        ])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let response = try? await session.data(for: request).1
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
}

extension NotificationsAPI {
    enum URLBuilder {
        private static var baseURL: URL? {
            .init(string: Configuration.notificationsAPIBaseURL)
        }
        
        static var healthURL: URL? {
            baseURL?.appending(path: "health")
        }
        
        static var registerURL: URL? {
            baseURL?.appending(path: "register")
        }
    }
}
