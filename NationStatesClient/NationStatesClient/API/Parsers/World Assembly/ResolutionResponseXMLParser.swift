//
//  ResolutionResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import Foundation

class ResolutionResponseXMLParser: NationStatesXMLParser {
    var resolution: ResolutionDTO = .init()
    private var foundCharacters: String = ""
    
    override init(_ data: Data) {
        super.init(data)
        self.parser.delegate = self
    }
}

extension ResolutionResponseXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string.trimmingCharacters(in: .newlines)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        resolution.text = String(data: CDATABlock, encoding: .utf8)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "CATEGORY":
            resolution.category = foundCharacters
        case "CREATED":
            if let unixStamp = TimeInterval(foundCharacters) {
                resolution.created = Date(timeIntervalSince1970: unixStamp)
            }
            break
        case "DESC":
            break
        case "ID":
            resolution.id = foundCharacters
        case "NAME":
            resolution.name = foundCharacters
        case "OPTION":
            resolution.option = foundCharacters
        case "PROMOTED":
            if let unixStamp = TimeInterval(foundCharacters) {
                resolution.promoted = Date(timeIntervalSince1970: unixStamp)
            }
            break
        case "PROPOSED_BY":
            resolution.proposedBy = foundCharacters
        case "TOTAL_NATIONS_AGAINST":
            resolution.totalNationsAgainst = Int(foundCharacters)
        case "TOTAL_NATIONS_FOR":
            resolution.totalNationsFor = Int(foundCharacters)
        case "TOTAL_VOTES_AGAINST":
            resolution.totalVotesAgainst = Int(foundCharacters)
        case "TOTAL_VOTES_FOR":
            resolution.totalVotesFor = Int(foundCharacters)
        default: break
        }
        foundCharacters = ""
    }
}
