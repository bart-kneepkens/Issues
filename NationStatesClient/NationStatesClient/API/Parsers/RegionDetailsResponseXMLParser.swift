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
            regionDTO.flagURL = foundCharacters
        case "BANNERURL":
            regionDTO.bannerURL = "https://www.nationstates.net\(foundCharacters)"
        default:
            break
        }
        
        foundCharacters = ""
    }
}
