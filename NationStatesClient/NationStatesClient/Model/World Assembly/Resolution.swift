//
//  Resolution.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 29/12/2020.
//

import Foundation

struct Resolution {
    let category: String
    let created: Date
    let text: String
    let id: String
    let name: String
    let option: String
    let promoted: Date
    let proposedBy: String
    let totalNationsAgainst: Int
    let totalNationsFor: Int
    let totalVotesAgainst: Int
    let totalVotesFor: Int
    
    var information: ResolutionInformation?
}

extension Resolution: DTOInitializable {
    typealias DTOEquivalent = ResolutionDTO
    init?(from dto: ResolutionDTO) {
        guard let category = dto.category, let created = dto.created, let text = dto.text, let id = dto.id, let name = dto.name, let option = dto.option, let promoted = dto.promoted, let proposedBy = dto.proposedBy, let totalNationsAgainst = dto.totalNationsAgainst, let totalNationsFor = dto.totalNationsFor, let totalVotesAgainst = dto.totalVotesAgainst, let totalVotesFor = dto.totalNationsFor else { return nil }
        
        self.init(category: category, created: created, text: text, id: id, name: name, option: option, promoted: promoted, proposedBy: proposedBy, totalNationsAgainst: totalNationsAgainst, totalNationsFor: totalNationsFor, totalVotesAgainst: totalVotesAgainst, totalVotesFor: totalVotesFor, information: nil)
    }
}

struct ResolutionDTO: Equatable {
    var category: String?
    var created: Date?
    var text: String?
    var id: String?
    var name: String?
    var option: String?
    var promoted: Date?
    var proposedBy: String?
    var totalNationsAgainst: Int?
    var totalNationsFor: Int?
    var totalVotesAgainst: Int?
    var totalVotesFor: Int?
}

#if DEBUG
extension Resolution {
    static let filler = Resolution(category: "Regulation", created: Date(),
                                   text: """
        The World Assembly,

        [i]Recognising[/i] that radio technology is used by many member states for communication,

        [i]Lamenting[/i] the lack of international standards for radio communication,

        [i]Considering[/i] the detrimental effects that a lack of standards has on international radio communication, such as incompatibilities in equipment,

        [i]Especially worried[/i] that a lack of international cooperation could result in non-coordination and even interference in essential radio communications,

        [i]Aware[/i] that sudden regulatory changes are likely to cause severe confusion in existing radio transmissions,

        Hereby enacts as follows:

        [list]
        [*][b]International Radiocommunications Authority[/b]: There shall be an International Radiocommunications Authority (IRA), which shall be an organ of the WA Scientific Programme.
        [*][b]Radio spectrum allocations[/b]: For each member state using radio for communication, the IRA shall allocate parts of the radio spectrum for each relevant kind of communication in that state, which shall include at least public broadcasting and recreational use. The allocations shall be made considering the existing use in that state and other nearby states, in order to increase compatibility of standards between nations while minimising inconvenience to existing radio transmission. Member states shall be required to comply with these allocations after a reasonable transition period fixed by the IRA. The allocations may be changed from time to time by consultation between the IRA and member states.
        [*][b]Registry of radio transmitters[/b]: Member states shall maintain a registry, revised frequently, of all persons or institutions equipped to transmit radio signals which can be recieved over long distances, and shall allocate frequencies to each of them if necessary to avoid interference of signals. Member states shall submit this registry to the IRA regularly. Member states shall make freely available all portions of the registry for which doing so would not unduly infringe on privacy or national security.
        [*][b]Restrictions on equipment[/b]: [list=a]
        [*]Member states may: [list=i]
        [*]Prohibit or restrict the manufacture, sale or purchase of equipment capable of transmitting radio signals outside the ranges allocated for public broadcasting and recreational use,
        [*]Require that equipment capable of transmitting radio signals, other than equipment solely for private communication on frequencies specified for that purpose (such as mobile telephones) only be sold to persons licensed to operate such equipment, provided such licensing is widely available without unreasonable costs or restrictions,
        [*]Prohibit or restrict the manufacture, sale or purchase of equipment capable of receiving radio signals in any ranges allocated for secret military or security communication, or
        [*]Prohibit the transmission of radio signals at a power which is likely to injure or kill any sentient beings living in that area, except in a contained environment for scientific research.[/list]
        [*]Member states may not impose unreasonable restrictions on the manufacture, sale or purchase of equipment for transmitting or receiving radio signals which are not covered by article 4a.[/list][/list]
        """,
                                   id: "id", name: "International Radio Standards Act", option: "Safety", promoted: Date(), proposedBy: "Elest Adra", totalNationsAgainst: 1337, totalNationsFor: 16, totalVotesAgainst: 420, totalVotesFor: 421, information: nil)
}
#endif
