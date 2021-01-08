//
//  APIRequest.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/01/2021.
//

import Foundation
import Combine

class APIRequest {
    private let url: URL
    private let authenticationContainer: AuthenticationContainer
    private let session: NetworkSession
    
    init(url: URL, authenticationContainer: AuthenticationContainer, session: NetworkSession = URLSession.shared) {
        self.url = url
        self.authenticationContainer = authenticationContainer
        self.session = session
    }
    
    private var request: URLRequest {
        var request = URLRequest(url: url)
        request.setupUserAgentHeader(nationName: self.authenticationContainer.nationName)
        return request
    }
    
    var publisher: AnyPublisher<DataResponse, APIError> {
        session.publisher(for: self.request)
            .tryMap { (output) -> DataResponse in
                try output.response.throwHTTPErrors()
                return output
            }
            .mapError({ error -> APIError in
                return error.asAPIError
            })
            .retry(2)
            .eraseToAnyPublisher()
    }
}
