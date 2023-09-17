//
//  BBCodeConverter.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 17/09/2023.
//

import Foundation
import SwiftSoup

class BBCodeConverter {
    private let bbCodeRawText: String
    
    init(bbCodeRawText: String) {
        self.bbCodeRawText = bbCodeRawText
    }
    
    lazy var htmlText: String = {
        convertBBCodeToHTML(bbCodeRawText)
    }()
}

extension BBCodeConverter {
    
    func convertBBCodeToHTML(_ input: String) -> String {
        var output = input

        // Replace [b]...[/b] with <strong>...</strong>
        output = output.replacingOccurrences(of: "\\[b\\](.*?)\\[/b\\]", with: "<strong>$1</strong>", options: .regularExpression)

        // Replace [color=#hex]...[/color] with <span style="color: #hex;">...</span>
        output = output.replacingOccurrences(of: "\\[color=(#[0-9A-Fa-f]+)\\](.*?)\\[/color\\]", with: "<span style=\"color: $1;\">$2</span>", options: .regularExpression)

        // Replace [url=...]...[/url] with <a href="...">...</a>
        output = output.replacingOccurrences(of: "\\[url=(.*?)\\](.*?)\\[/url\\]", with: "<a href=\"$1\">$2</a>", options: .regularExpression)

        // Replace [I]...[/I] with <em>...</em>
        output = output.replacingOccurrences(of: "\\[I\\](.*?)\\[/I\\]", with: "<em>$1</em>", options: .regularExpression)

        // Replace special character codes like &amp;#127987; with their corresponding HTML entities
        
        let regex = try! NSRegularExpression(pattern: "&amp;#([0-9]+);") // try! should be fine here since the input does not change, an error should indicate programmer error.
        let matches = regex.matches(in: output, range: NSRange(output.startIndex..., in: output))

        for match in matches.reversed() {
            if let range = Range(match.range(at: 1), in: output),
               let code = Int(output[range]),
               let scalar = UnicodeScalar(code) {
                let character = String(scalar)

                if let rangeToReplace = Range(match.range, in: output) {
                    output = output.replacingCharacters(in: rangeToReplace, with: character)
                }
            }
        }

        // Replace full nation links with relative ones
        output = output.replacingOccurrences(of: "https://www.nationstates.net/nation=", with: "/nation=")
        
        // TODO: Replace region links with relative ones?

        // Replace line breaks with <br> tags
        output = output.replacingOccurrences(of: "\\n", with: "<br>", options: .regularExpression)

        // Remove any remaining BBCode tags
        output = output.replacingOccurrences(of: "\\[.*?\\]", with: "", options: .regularExpression)

        // Replace any remaining &amp; with &
        output = output.replacingOccurrences(of: "&amp;", with: "&")

        return output
    }
}
