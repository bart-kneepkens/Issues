//
//  IssuesResponseXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 10/10/2020.
//

import Foundation

class IssuesResponseXMLParser: NationStatesXMLParser {
    var issues: [IssueDTO] = []
    private var currentIssue: IssueDTO = .init()
    private var currentOption: OptionDTO = .init()
    private var foundCharacters: String = ""
    
    override init(_ data: Data) {
        super.init(data)
        self.parser.delegate = self
    }
}

extension IssuesResponseXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string.trimmingCharacters(in: .newlines)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "ISSUE" {
            if let idString = attributeDict["id"] {
                currentIssue.id = Int(idString)
            }
        }
        if elementName == "OPTION" {
            if let idString = attributeDict["id"] {
                currentOption.id = Int(idString)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "TITLE":
            currentIssue.title = foundCharacters
        case "TEXT":
            currentIssue.text = foundCharacters
        case "AUTHOR":
            currentIssue.author = foundCharacters
        case "EDITOR":
            currentIssue.editor = foundCharacters
        case "PIC1":
            currentIssue.pic1 = foundCharacters
        case "PIC2":
            currentIssue.pic2 = foundCharacters
        case "OPTION":
            currentOption.text = foundCharacters
            currentIssue.options.append(currentOption)
            currentOption = .init()
        case "ISSUE":
            issues.append(currentIssue)
            currentIssue = .init()
        default: break
        }
        
        foundCharacters = ""
    }
}
