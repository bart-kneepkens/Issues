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

extension Resolution {
    var timeLeftToVote: TimeInterval? {
        let voteEndsAt = self.promoted.addingTimeInterval(96 * 60 * 60) // Votes end in 4 days after being promoted
        let differenceInTime = Date().distance(to: voteEndsAt)
        
        if differenceInTime > 0 {
            return differenceInTime
        }
        
        return nil
    }
}

extension Resolution: DTOInitializable {
    typealias DTOEquivalent = ResolutionDTO
    init?(from dto: ResolutionDTO) {
        guard let category = dto.category, let created = dto.created, let id = dto.id, let name = dto.name, let option = dto.option, let promoted = dto.promoted, let proposedBy = dto.proposedBy, let totalNationsAgainst = dto.totalNationsAgainst, let totalNationsFor = dto.totalNationsFor, let totalVotesAgainst = dto.totalVotesAgainst, let totalVotesFor = dto.totalVotesFor else { return nil }
        
        self.init(category: category, created: created, id: id, name: name, option: option, promoted: promoted, proposedBy: proposedBy, totalNationsAgainst: totalNationsAgainst, totalNationsFor: totalNationsFor, totalVotesAgainst: totalVotesAgainst, totalVotesFor: totalVotesFor, information: nil)
    }
}

struct ResolutionDTO: Equatable {
    var category: String?
    var created: Date?
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
    static let filler = Resolution(
        category: "Regulation",
        created: Date(),
        id: "id",
        name: "International Radio Standards Act",
        option: "Safety",
        promoted: Date(),
        proposedBy: "Elest Adra",
        totalNationsAgainst: 1337,
        totalNationsFor: 16,
        totalVotesAgainst: 420,
        totalVotesFor: 421,
        information: nil
    )
}
#endif
