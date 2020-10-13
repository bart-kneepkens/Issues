//
//  NationStatesAPI.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

struct NationStatesAPI {}

enum Shard: String {
    case ping
    case issues
}

extension NationStatesAPI {
    static func ping(nationName: String,
                     password: String,
                     _ completionHandler: @escaping (Result<(autologin: String?, pin: String?), APIError>) -> Void) {
        guard let url = URLBuilder.url(for: nationName, with: .ping) else { fatalError() }
        
        var request = URLRequest(url: url)
        request.addValue(password, forHTTPHeaderField: "X-Password")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 403 {
                completionHandler(.failure(.unauthorized))
            } else if httpResponse.statusCode == 409 {
                completionHandler(.failure(.conflict))
            }
            
            guard error == nil else { return }
            guard let data = data else { return }
            
            let parser = PingResponseXMLParser(data)
            parser.parse()
            
            if parser.ping {
                let autoLogin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.autologin("").header)
                let pin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.pin("").header)
                completionHandler(.success((autoLogin, pin)))
            } else {
                completionHandler(.failure(.pingFailed))
            }
        }.resume()
    }
}

extension NationStatesAPI {
    static func answerIssue(_ issue: Issue,
                            option: Option,
                            completionHandler: @escaping (Result<String, APIError>) -> Void) {
        guard let nationName = Authentication.shared.nationName else { fatalError() }
        guard let url = URLBuilder.answerIssueUrl(for: nationName, issue: issue, option: option) else { fatalError() }
        guard let password = Authentication.shared.password else { fatalError() }
        
        var request = URLRequest(url: url)
        request.addValue(password, forHTTPHeaderField: "X-Password")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 403 {
                    completionHandler(.failure(.unauthorized))
                } else if httpResponse.statusCode == 409 {
                    completionHandler(.failure(.conflict))
                }
            }
            
            guard error == nil else { return }
            guard let data = data else { return }
            
            let parser = AnswerIssueResponseXMLParser(data)
            parser.parse()
            
            guard parser.ok else { return }
            completionHandler(.success(parser.text))
        }
    }
}

enum APIError: Error {
    case unauthorized // 403
    case conflict // 409
    case pingFailed
}

extension NationStatesAPI {
    static func request(for shards: [Shard],
                        nation nationName: String,
                        completionHandler: @escaping (Result<[IssueDTO], APIError>) -> Void) {
        guard let url = URLBuilder.url(for: nationName, with: .issues) else { fatalError() }
//        guard let password = AuthenticationMode.shared.password else { fatalError() }
    
        var request = URLRequest(url: url)
//        request.addValue(password, forHTTPHeaderField: "X-Password")
        
        URLSession
            .shared
            .dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 403 {
                        completionHandler(.failure(.unauthorized))
                    } else if httpResponse.statusCode == 409 {
                        completionHandler(.failure(.conflict))
                    }
                }
                guard error == nil else { return }
                guard let data = data else { return }

                let parser = IssuesResponseXMLParser(data)
                parser.parse()
                
                completionHandler(.success(parser.issues))
        }.resume()
    }
}
