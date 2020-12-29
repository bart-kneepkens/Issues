//
//  NationDetailsResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation

class NationDetailsResponseXMLParser: NationStatesXMLParser {
    var nationDTO = NationDTO()
    
    private var civilRightsDTO = FreedomDTO()
    private var economyDTO = FreedomDTO()
    private var politicalFreedomDTO = FreedomDTO()
    
    private var currentCensusId: Int?
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
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "SCALE" {
            if let idString = attributeDict["id"] {
                self.currentCensusId = Int(idString)
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "TYPE": self.nationDTO.type = foundCharacters
        case "NAME": self.nationDTO.name = foundCharacters
        case "FULLNAME": self.nationDTO.fullName = foundCharacters
            // Motto can contain unicode code point values, so use a transform.
        case "MOTTO": self.nationDTO.motto = foundCharacters.applyingTransform(.HexAny, reverse: false) ?? foundCharacters
        case "CATEGORY": self.nationDTO.category = foundCharacters
        case "FLAG": self.nationDTO.flagURL = foundCharacters
        case "POPULATION": self.nationDTO.populationMillions = Int(foundCharacters)
        case "INFLUENCE": self.nationDTO.regionInfluence = foundCharacters
        case "REGION": self.nationDTO.regionName = foundCharacters
        case "CURRENCY": self.nationDTO.currency = foundCharacters
        case "ANIMAL": self.nationDTO.animal = foundCharacters
            // Freedom scales
        case "CIVILRIGHTS": self.civilRightsDTO.text = foundCharacters
        case "ECONOMY": self.economyDTO.text = foundCharacters
        case "POLITICALFREEDOM": self.politicalFreedomDTO.text = foundCharacters
        case "SCORE":
            let scoreValue = Double(foundCharacters)
            switch currentCensusId {
            case 0: self.civilRightsDTO.score = scoreValue
            case 1: self.economyDTO.score = scoreValue
            case 2: self.politicalFreedomDTO.score = scoreValue
            default: break
            }
        case "RANK":
            let rankValue = Int(foundCharacters)
            switch currentCensusId {
            case 0: self.civilRightsDTO.rank = rankValue
            case 1: self.economyDTO.rank = rankValue
            case 2: self.politicalFreedomDTO.rank = rankValue
            default: break
            }
        case "RRANK":
            let regionRankValue = Int(foundCharacters)
            switch currentCensusId {
            case 0: self.civilRightsDTO.regionRank = regionRankValue
            case 1: self.economyDTO.regionRank = regionRankValue
            case 2: self.politicalFreedomDTO.regionRank = regionRankValue
            default: break
            }
        default: break
        }
        
        foundCharacters = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        nationDTO.freedoms = FreedomsDTO(civilRights: civilRightsDTO, economy: economyDTO, politicalFreedom: politicalFreedomDTO)
    }
}
