//
//  WorldAssemblyResolutionTextSheet.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 02/01/2021.
//

import SwiftUI

struct WorldAssemblyResolutionTextSheet: View {
    let htmlText: String
    
    init(htmlText: String) {
        self.htmlText = htmlText
    }
    
    private var onNationTapped: ((String) -> Void)? = nil
    
    private static func nationName(for url: String) -> String? {
        guard url.contains("nation=") else { return nil }
        return url.components(separatedBy: "=")[1]
    }
    
    @ViewBuilder private var htmlView: some View {
        HTMLTextWebView(html: htmlText)
            .onLinkTap { url in
                if let onNationTapped = self.onNationTapped, let nationName = WorldAssemblyResolutionTextSheet.nationName(for: url) {
                    onNationTapped(nationName)
                }
                // TODO: resolution links
            }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea(.all, edges: .bottom)
            VStack {
                Color.clear.frame(height: 14) // This is used to replicate List as .sheet behavior, acts as a sort of 'handle' to swipe down.
                Color(UIColor.secondarySystemGroupedBackground)
                    .cornerRadius(13)
                    .overlay(htmlView)
                    .padding()
            }
            
        }
    }
}

extension WorldAssemblyResolutionTextSheet {
    @inlinable public func onNationTap(perform action: ((String) -> Void)? = nil) -> some View {
        var copy = self
        copy.onNationTapped = action
        return copy
    }
}

struct WorldAssemblyResolutionTextSheet_Previews: PreviewProvider {
    static var previews: some View {
        WorldAssemblyResolutionTextSheet(htmlText: """
            <div class="WA_thing_body"><p>The World Assembly,</p><p><i>Recognising</i> that radio technology is used by many member states for communication,</p><p><i>Lamenting</i> the lack of international standards for radio communication,</p><p><i>Considering</i> the detrimental effects that a lack of standards has on international radio communication, such as incompatibilities in equipment,</p><p><i>Especially worried</i> that a lack of international cooperation could result in non-coordination and even interference in essential radio communications,</p><p><i>Aware</i> that sudden regulatory changes are likely to cause severe confusion in existing radio transmissions,</p><p>Hereby enacts as follows:</p><p></p><ol><li><p><b>International Radiocommunications Authority</b>: There shall be an International Radiocommunications Authority (IRA), which shall be an organ of the WA Scientific Programme.</p></li><li><p><b>Radio spectrum allocations</b>: For each member state using radio for communication, the IRA shall allocate parts of the radio spectrum for each relevant kind of communication in that state, which shall include at least public broadcasting and recreational use. The allocations shall be made considering the existing use in that state and other nearby states, in order to increase compatibility of standards between nations while minimising inconvenience to existing radio transmission. Member states shall be required to comply with these allocations after a reasonable transition period fixed by the IRA. The allocations may be changed from time to time by consultation between the IRA and member states.</p></li><li><p><b>Registry of radio transmitters</b>: Member states shall maintain a registry, revised frequently, of all persons or institutions equipped to transmit radio signals which can be recieved over long distances, and shall allocate frequencies to each of them if necessary to avoid interference of signals. Member states shall submit this registry to the IRA regularly. Member states shall make freely available all portions of the registry for which doing so would not unduly infringe on privacy or national security.</p></li><li><p><b>Restrictions on equipment</b>: </p><ol style="list-style-type:lower-latin"><li><p>Member states may: </p><ol style="list-style-type:lower-roman"><li><p>Prohibit or restrict the manufacture, sale or purchase of equipment capable of transmitting radio signals outside the ranges allocated for public broadcasting and recreational use,</p></li><li><p>Require that equipment capable of transmitting radio signals, other than equipment solely for private communication on frequencies specified for that purpose (such as mobile telephones) only be sold to persons licensed to operate such equipment, provided such licensing is widely available without unreasonable costs or restrictions,</p></li><li><p>Prohibit or restrict the manufacture, sale or purchase of equipment capable of receiving radio signals in any ranges allocated for secret military or security communication, or</p></li><li><p>Prohibit the transmission of radio signals at a power which is likely to injure or kill any sentient beings living in that area, except in a contained environment for scientific research.</p></li></ol><p></p></li><li><p>Member states may not impose unreasonable restrictions on the manufacture, sale or purchase of equipment for transmitting or receiving radio signals which are not covered by article 4a.</p></li></ol><p></p></li></ol><p></p></div>
            """)
    }
}
