//
//  URLBuilder.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 11/10/2020.
//

import Foundation

fileprivate let API_VERSION_QUERY_ITEM = URLQueryItem(name: "v", value: "11")

struct URLBuilder {
    fileprivate static let baseUrl = URL(string: "https://www.nationstates.net/cgi-bin/api.cgi")!
    
    static func url(for nationName: String, with shard: Shard) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        
        components.queryItems = [
            API_VERSION_QUERY_ITEM,
            URLQueryItem(name: "nation", value: nationName),
            URLQueryItem(name: "q", value: shard.rawValue),
        ]
        
        return components.url
    }
    
    static func url(for nationName: String, with shards: [Shard]) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        
        components.queryItems = [
            API_VERSION_QUERY_ITEM,
            URLQueryItem(name: "nation", value: nationName),
            URLQueryItem(name: "q", value: shards.map({ $0.rawValue }).joined(separator: "+")),
        ]
        
        return components.url
    }
    
    static func nationDetailsUrl(for nationName: String) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        let shards: [Shard] = [.category,
                               .flag,
                               .motto,
                               .type,
                               .fullname,
                               .name,
                               .freedom,
                               .census,
                               .population,
                               .region,
                               .influence,
                               .currency,
                               .animal]
        
        components.queryItems = [
            API_VERSION_QUERY_ITEM,
            URLQueryItem(name: "nation", value: nationName),
            URLQueryItem(name: "q", value: shards.map({ $0.rawValue }).joined(separator: "+")),
            URLQueryItem(name: "scale", value: [0,1,2].map({ String($0) }).joined(separator: "+")), // Represent the 3 census in 'freedoms'
        ]
        
        return components.url
    }
    
    static func answerIssueUrl(for nationName: String, issue: Issue, option: Option) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        
        components.queryItems = [
            API_VERSION_QUERY_ITEM,
            URLQueryItem(name: "nation", value: nationName),
            URLQueryItem(name: "c", value: "issue"),
            URLQueryItem(name: "issue", value: String(issue.id)),
            URLQueryItem(name: "option", value: String(option.id)),
        ]
        
        return components.url
    }
    
    static func imageUrl(for imageName: String) -> URL? {
        return URL(string: "https://www.nationstates.net/images/newspaper/\(imageName)-1.jpg")
    }
}
