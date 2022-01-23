//
//  Nation.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation

struct NationDTO: Equatable {
    var flagURL: String?
    var name: String?
    var fullName: String?
    var motto: String?
    var category: String?
    var type: String?
    var freedoms: FreedomsDTO?
    var populationMillions: Int?
    var currency: String?
    var regionName: String?
    var regionInfluence: String?
    var animal: String?
    
    var generalAssemblyVote: VoteOption?
    var securityCouncilVote: VoteOption?
}

struct Nation {
    let flagURL: String
    let name: String
    let fullName: String
    let motto: String
    let category: String
    let type: String
    let freedoms: Freedoms
    let populationMillions: Int
    let currency: String
    let regionName: String
    let regionInfluence: String
    let animal: String
    
    let generalAssemblyVote: VoteOption?
    let securityCouncilVote: VoteOption?
}

extension Nation: DTOInitializable {
    typealias DTOEquivalent = NationDTO
    
    init?(from dto: NationDTO) {
        guard let flagURL = dto.flagURL,
              let name = dto.name,
              let fullName = dto.fullName,
              let motto = dto.motto,
              let category = dto.category,
              let type = dto.type,
              let freedomsDTO = dto.freedoms,
              let freedoms = Freedoms(from: freedomsDTO),
              let populationMillions = dto.populationMillions,
              let currency = dto.currency,
              let regionName = dto.regionName,
              let regionInfluence = dto.regionInfluence,
              let animal = dto.animal
              else { return nil }
        self.init(flagURL: flagURL, name: name, fullName: fullName, motto: motto, category: category, type: type, freedoms: freedoms, populationMillions: populationMillions, currency: currency, regionName: regionName, regionInfluence: regionInfluence, animal: animal, generalAssemblyVote: dto.generalAssemblyVote, securityCouncilVote: dto.securityCouncilVote)
    }
}

#if DEBUG
extension Nation {
    static let filler = Nation(flagURL: "https://www.nationstates.net/images/flags/Djibouti.png",
                               name: "Elest Adra",
                               fullName: "The Democratic Republic of Elest Adra",
                               motto: "Strength Through Freedom",
                               category: "Capitalizt",
                               type: "Democratic Republic",
                               freedoms: Freedoms(civilRights: .init(score: 77.03, rank: 34024, regionRank: 799, text: "Superb"),
                                                  economy: .init(score: 74.17, rank: 82472, regionRank: 4198, text: "Very Strong"),
                                                  politicalFreedom: .init(score: 72.29, rank: 66931, regionRank: 2014, text: "Excellent")),
                               populationMillions: 2046,
                               currency: "eurodollar",
                               regionName: "Greater Night City",
                               regionInfluence: "Nihil",
                               animal: "Turtle",
                               generalAssemblyVote: nil,
                               securityCouncilVote: nil)
}
#endif

