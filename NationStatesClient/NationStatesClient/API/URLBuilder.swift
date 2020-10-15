//
//  URLBuilder.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 11/10/2020.
//

import Foundation

struct URLBuilder {
    fileprivate static let baseUrl = URL(string: "https://www.nationstates.net/cgi-bin/api.cgi")!
    
    static func url(for nationName: String, with shard: Shard) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "nation", value: nationName),
            URLQueryItem(name: "q", value: shard.rawValue),
        ]
        
        return components.url
    }
    
    static func answerIssueUrl(for nationName: String, issue: Issue, option: Option) -> URL? {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }
        
        components.queryItems = [
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
