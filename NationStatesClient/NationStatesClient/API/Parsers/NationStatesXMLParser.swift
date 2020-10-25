//
//  NationStatesXMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 11/10/2020.
//

import Foundation

class NationStatesXMLParser: NSObject {
    var parser: XMLParser
    
    init(_ data: Data) {
        self.parser = XMLParser(data: data)
    }
    
    func parse() {
        self.parser.parse()
    }
}

