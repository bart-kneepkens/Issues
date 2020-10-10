//
//  NationStatesAPI.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

enum NationStates {
    static let baseUrl = URL(string: "https://www.nationstates.net/cgi-bin/api.cgi")!
}

enum Shard: String {
    case issues
}

typealias IssuesResponse = [IssueDTO]

extension NationStates {
    static func url(for shards: [Shard], nation nationName: String) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "nation", value: nationName),
            URLQueryItem(name: "q", value: shards.map({ $0.rawValue }).joined(separator: "+")),
        ]
        
        return components.url
    }
}

enum APIError: Error {
    case unauthorized
}

extension NationStates {
    static func request(for shards: [Shard],
                        nation nationName: String,
                        completionHandler: @escaping (Result<IssuesResponse, APIError>) -> Void) {
        guard let url = NationStates.url(for: shards, nation: nationName) else { fatalError() }
        guard let password = Authorization.shared.password else { fatalError() }
    
        var request = URLRequest(url: url)
        request.addValue(password, forHTTPHeaderField: "X-Password")
        
        URLSession
            .shared
            .dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 403 {
                        completionHandler(.failure(.unauthorized))
                    }
                }
                guard error == nil else { return }
                guard let data = data else { return }
                let parser = XMLParser(data: data)
                let delegate = IssuesXMLParser()
                
                parser.delegate = delegate
                parser.parse()
                
                completionHandler(.success(delegate.issues))
        }.resume()
    }
}
