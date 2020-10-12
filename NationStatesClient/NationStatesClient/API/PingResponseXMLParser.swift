//
//  PingResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 12/10/2020.
//

import Foundation

class PingResponseXMLParser: NationStatesXMLParser {
    var ping: Bool = false
    
    private var foundCharacters: String = ""
    
    override init(_ data: Data) {
        super.init(data)
        self.parser.delegate = self
    }
}

extension PingResponseXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "PING" {
            self.ping = foundCharacters == "1" ? true : false
            self.parser.abortParsing() // done
        }
    }
}
