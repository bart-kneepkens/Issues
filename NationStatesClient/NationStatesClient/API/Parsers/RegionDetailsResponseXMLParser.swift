//
//  RegionDetailsResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/09/2023.
//

import Foundation

class RegionDetailsResponseXMLParser: NationStatesXMLParser {
    var regionDTO = RegionDTO()
    
    private var foundCharacters: String = ""
    
    override init(_ data: Data) {
        super.init(data)
        self.parser.delegate = self
    }
}

extension RegionDetailsResponseXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string.trimmingCharacters(in: .newlines)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        if let bbCode = String(data: CDATABlock, encoding: .utf8) {
            regionDTO.factbookHTML = BBCodeConverter(bbCodeRawText: bbCode).htmlText
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "NAME":
            regionDTO.name = foundCharacters
        case "NUMNATIONS":
            regionDTO.numberOfNations = Int(foundCharacters)
        case "DELEGATE":
            regionDTO.delegateNationName = foundCharacters
        case "POWER":
            regionDTO.power = foundCharacters
        case "FLAG":
            if !foundCharacters.isEmpty {
                regionDTO.flagURL = foundCharacters
            }
        case "BANNERURL":
            regionDTO.bannerURL = "https://www.nationstates.net\(foundCharacters)"
        case "FOUNDER":
            if foundCharacters != "0" {
                regionDTO.founderName = foundCharacters
            }
        case "FOUNDEDTIME":
            if let unixStamp = TimeInterval(foundCharacters) {
                regionDTO.foundedTime = Date(timeIntervalSince1970: unixStamp)
            }
            break
        default:
            break
        }
        
        foundCharacters = ""
    }
}
