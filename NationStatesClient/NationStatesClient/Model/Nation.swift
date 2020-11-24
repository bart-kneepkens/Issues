//
//  Nation.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation

struct Freedom {
    let civilRights: String
    let economy: String
    let politicalFreedom: String
}

extension Freedom: DTOInitializable {
    typealias DTOEquivalent = FreedomDTO
    
    init?(from dto: FreedomDTO) {
        guard let civilRights = dto.civilRights, let economy = dto.economy, let politicalFreedom = dto.politicalFreedom else { return nil }
        self.init(civilRights: civilRights, economy: economy, politicalFreedom: politicalFreedom)
    }
}

struct FreedomDTO: Equatable {
    var civilRights: String?
    var economy: String?
    var politicalFreedom: String?
}

struct Nation {
    let flagURL: String
    let name: String
    let fullName: String
    let motto: String
    let category: String
    let type: String
    let freedom: Freedom
}

struct NationDTO: Equatable {
    var flagURL: String?
    var name: String?
    var fullName: String?
    var motto: String?
    var category: String?
    var type: String?
    var freedom: FreedomDTO?
}

extension Nation: DTOInitializable {
    typealias DTOEquivalent = NationDTO
    
    init?(from dto: NationDTO) {
        guard let flagURL = dto.flagURL, let name = dto.name, let fullName = dto.fullName, let motto = dto.motto, let category = dto.category, let type = dto.type, let freedomDTO = dto.freedom, let freedom = Freedom(from: freedomDTO) else { return nil }
        self.init(flagURL: flagURL, name: name, fullName: fullName, motto: motto, category: category, type: type, freedom: freedom)
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
                               freedom: .init(civilRights: "Superb", economy: "Superb", politicalFreedom: "Superb"))
}
#endif

