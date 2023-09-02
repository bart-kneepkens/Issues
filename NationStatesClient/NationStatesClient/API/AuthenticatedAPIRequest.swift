//
//  AuthenticatedAPIRequest.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 04/11/2020.
//

import Foundation
import Combine

class AuthenticatedAPIRequest {
    private let url: URL
    private let authenticationContainer: AuthenticationContainer
    private let session: NetworkSession
    
    init(url: URL, authenticationContainer: AuthenticationContainer, session: NetworkSession = URLSession.shared) {
        self.url = url
        self.authenticationContainer = authenticationContainer
        self.session = session
    }
    
    var authenticated: URLRequest {
        var request = URLRequest(url: url)
        request.setupUserAgentHeader(nationName: self.authenticationContainer.nationName)
        
        if let pin = self.authenticationContainer.pin {
            request.setupPinHeader(pin)
        } else if let autologin = self.authenticationContainer.autologin {
            request.setupAutologinHeader(autologin)
        } else {
            request.setupPasswordAuthenticationHeader(self.authenticationContainer.password)
        }
        
        print("Authenticated API Request with url \(url.absoluteString) with headers: \(request.allHTTPHeaderFields ?? [:])")
        
        return request
    }
    
    var response: DataResponse {
        get async throws {
            let dataResponse = try await session.asyncData(for: self.authenticated)
            try dataResponse.response.throwHTTPErrors(data: dataResponse.data)
            
            if let httpResponse = dataResponse.response as? HTTPURLResponse {
                if let autoLogin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.autologin.header) {
                    self.authenticationContainer.autologin = autoLogin
                    print("Set auth AUTOLOGIN")
                }
                if let pin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.pin.header) {
                    self.authenticationContainer.pin = pin
                    print("Set auth PIN")
                }
            }
            
            return dataResponse
        }
    }
    
    var publisher: AnyPublisher<DataResponse, APIError> {
        self.session.publisher(for: self.authenticated)
            .tryMap({ output -> DataResponse in
                try output.response.throwHTTPErrors(data: output.data)
                return output
            })
            .tryCatch({ error -> AnyPublisher<DataResponse, APIError> in
                guard let apiError = error as? APIError, self.authenticationContainer.pin != nil || self.authenticationContainer.autologin != nil else {
                    throw error
                }
                
                switch apiError {
                case .conflict:
                    print("HTTP call failed with 409, retrying without PIN header")
                    self.authenticationContainer.pin = nil
                    return AuthenticatedAPIRequest(url: self.url, authenticationContainer: self.authenticationContainer, session: self.session).publisher
                case .unauthorized:
                    print("HTTP call failed with 403, retrying without PIN header and autologin")
                    self.authenticationContainer.pin = nil
                    self.authenticationContainer.autologin = nil
                    return AuthenticatedAPIRequest(url: self.url, authenticationContainer: self.authenticationContainer, session: self.session).publisher
                default: throw apiError
                }
                
            })
            .mapError({ error -> APIError in
                return error.asAPIError
            })
            .handleEvents(receiveOutput: { output in
                if let httpResponse = output.response as? HTTPURLResponse {
                    if let autoLogin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.autologin.header) {
                        self.authenticationContainer.autologin = autoLogin
                        print("Set auth AUTOLOGIN")
                    }
                    if let pin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.pin.header) {
                        self.authenticationContainer.pin = pin
                        print("Set auth PIN")
                    }
                }
            })
            .eraseToAnyPublisher()
    }
}
