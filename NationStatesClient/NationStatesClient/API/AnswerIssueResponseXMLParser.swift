//
//  AnswerIssueResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 11/10/2020.
//

import Foundation

class AnswerIssueResponseXMLParser: NationStatesXMLParser {
    var ok: Bool = false
    var text: String = ""
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
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "OK" {
            self.ok = foundCharacters == "1" ? true : false
            foundCharacters = ""
        }
        if elementName == "DESC" {
            self.text = foundCharacters
            foundCharacters = ""
            self.parser.abortParsing()
        }
    }
}
