//
//  ExperimentsAPI.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/02/2025.
//

import Foundation

final class ExperimentsAPI {
    
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
    
    func enroll(nationName: String, pin: String) async -> Bool {
        guard let url = URLBuilder.enrollURL?
            .appending(queryItems: [ .init(name: "pin", value: pin)])
        else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = nationName.data(using: .utf8)
        
        guard let response = try? await session.data(for: request).1 else { return false }
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    func undo(nationName: String, pin: String) async -> Bool {
        guard let url = URLBuilder.undoURL?
            .appending(path: nationName)
            .appending(queryItems: [ .init(name: "pin", value: pin)])
        else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        guard let response = try? await session.data(for: request).1 else { return false }
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
}

extension ExperimentsAPI {
    enum URLBuilder {
        private static var baseURL: URL? {
            .init(string: Configuration.experimentsAPIBaseURL)
        }
        
        static var healthURL: URL? {
            baseURL?.appending(path: "health")
        }
        
        static var enrollURL: URL? {
            baseURL?.appending(path: "enroll")
        }
        
        static var undoURL: URL? {
            baseURL?.appending(path: "undo")
        }
    }
}
