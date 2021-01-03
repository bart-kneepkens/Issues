//
//  WorldAssemblyHTMLParser.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import Foundation
import Swift
import SwiftSoup

fileprivate extension String {
    // https://en.wikipedia.org/wiki/Windows-1252
    // https://gist.github.com/nathanfjohnson/380b9f24c991a8970144e13ddd044d21
    private var windowsChars: [String: String] {
        ["&#128;": "\u{20AC}",
         "&#130;": "\u{201A}",
         "&#131;": "\u{0192}",
         "&#132;": "\u{201E}",
         "&#133;": "\u{2026}",
         "&#134;": "\u{2020}",
         "&#135;": "\u{2021}",
         "&#136;": "\u{02C6}",
         "&#138;": "\u{0160}",
         "&#139;": "\u{2039}",
         "&#140;": "\u{0152}",
         "&#142;": "\u{017D}",
         "&#145;": "\u{2018}",
         "&#146;": "\u{2019}",
         "&#147;": "\u{201C}",
         "&#148;": "\u{201D}",
         "&#149;": "\u{2022}",
         "&#150;": "\u{2013}",
         "&#151;": "\u{2014}",
         "&#152;": "\u{02DC}",
         "&#153;": "\u{2122}",
         "&#154;": "\u{0161}",
         "&#155;": "\u{203A}",
         "&#156;": "\u{0153}",
         "&#158;": "\u{017E}",
         "&#159;": "\u{0178}"]
    }
    
    var withWindows1252CharactersSanitized: String {
        var html = self
        for windowsChar in windowsChars {
            html = html.replacingOccurrences(of: windowsChar.key, with: windowsChar.value)
        }
        return html
    }
}


class WorldAssemblyHTMLParser {
    var localId: String?
    var htmlText: String?
    
    init(_ htmlString: String) {
        if let document = try? SwiftSoup.parse(htmlString.withWindows1252CharactersSanitized) {
            self.localId = try? document.select("[name=localid]").attr("value")
            self.htmlText = try? document.select(".WA_thing_body").html()
        }
    }
}
