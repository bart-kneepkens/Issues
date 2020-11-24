//
//  NationDetailsResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation

class NationDetailsResponseXMLParser: NationStatesXMLParser {
    var nationDTO = NationDTO()
    private var freedomDTO = FreedomDTO()
    
    private var foundCharacters: String = ""
    
    override init(_ data: Data) {
        super.init(data)
        self.parser.delegate = self
    }
}

extension NationDetailsResponseXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string.trimmingCharacters(in: .newlines)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case "TYPE": self.nationDTO.type = foundCharacters
        case "NAME": self.nationDTO.name = foundCharacters
        case "FULLNAME": self.nationDTO.fullName = foundCharacters
        case "MOTTO": self.nationDTO.motto = foundCharacters
        case "CATEGORY": self.nationDTO.category = foundCharacters
        case "CIVILRIGHTS": self.freedomDTO.civilRights = foundCharacters
        case "ECONOMY": self.freedomDTO.economy = foundCharacters
        case "POLITICALFREEDOM": self.freedomDTO.politicalFreedom = foundCharacters
        case "FREEDOM": self.nationDTO.freedom = self.freedomDTO
        case "FLAG": self.nationDTO.flagURL = foundCharacters
        default: break
        }
        
        foundCharacters = ""
    }
}
