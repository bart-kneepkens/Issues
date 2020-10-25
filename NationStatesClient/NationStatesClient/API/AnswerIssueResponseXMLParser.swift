//
//  AnswerIssueResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 11/10/2020.
//

import Foundation

struct AnswerIssueResponse {
    let result: String
    let rankings: [RankingDTO]
    let reclassificiations: [ReclassifyDTO]
    let headlines: [HeadlineDTO]
}

struct RankingDTO: Equatable, Hashable {
    var id: Int?
    var score: Float?
    var change: Float?
    var percentualChange: Float?
}

struct ReclassifyDTO: Equatable, Hashable {
    var type: Int?
    var from: String?
    var to: String?
}

typealias HeadlineDTO = String

class AnswerIssueResponseXMLParser: NationStatesXMLParser {
    var ok: Bool = false
    var text: String = ""
    var rankings: [RankingDTO] = []
    var reclassifications: [ReclassifyDTO] = []
    var headlines: [HeadlineDTO] = []
    
    private var currentRanking: RankingDTO = .init()
    private var currentReclassification: ReclassifyDTO = .init()
    private var foundCharacters = ""
    
    override init(_ data: Data) {
        super.init(data)
        self.parser.delegate = self
    }
}

extension AnswerIssueResponseXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "RANK" {
            if let idString = attributeDict["id"] {
                self.currentRanking.id = Int(idString)
            }
        }
        
        if elementName == "RECLASSIFY" {
            if let typeString = attributeDict["type"] {
                self.currentReclassification.type = Int(typeString)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "OK" {
            self.ok = foundCharacters == "1" ? true : false
        }
        if elementName == "DESC" {
            self.text = "\(foundCharacters.prefix(1).capitalized)\(foundCharacters.dropFirst())." // Capitalize first word, since it's returned all lower case by the server.
        }
        if elementName == "SCORE" {
            self.currentRanking.score = Float(foundCharacters)
        }
        if elementName == "CHANGE" {
            self.currentRanking.change = Float(foundCharacters)
        }
        if elementName == "PCHANGE" {
            self.currentRanking.percentualChange = Float(foundCharacters)
        }
        if elementName == "RANK" {
            self.rankings.append(self.currentRanking)
            self.currentRanking = .init()
        }
        if elementName == "FROM" {
            self.currentReclassification.from = foundCharacters
        }
        if elementName == "TO" {
            self.currentReclassification.to = foundCharacters
        }
        if elementName == "RECLASSIFY" {
            self.reclassifications.append(self.currentReclassification)
            self.currentReclassification = .init()
        }
        if elementName == "HEADLINE" {
            self.headlines.append(foundCharacters)
        }
        
        foundCharacters = ""
    }
}
