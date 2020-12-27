//
//  Freedoms.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/12/2020.
//

import Foundation

struct FreedomsDTO: Equatable {
    var civilRights: FreedomDTO?
    var economy: FreedomDTO?
    var politicalFreedom: FreedomDTO?
}

struct Freedoms {
    let civilRights: Freedom
    let economy: Freedom
    let politicalFreedom: Freedom
}

extension Freedoms: DTOInitializable {
    typealias DTOEquivalent = FreedomsDTO
    
    init?(from dto: FreedomsDTO) {
        guard let civilRightsDTO = dto.civilRights, let civilRights = Freedom(from: civilRightsDTO), let economyDTO = dto.economy, let economy = Freedom(from: economyDTO), let politicalFreedomDTO = dto.politicalFreedom, let politicalFreedom = Freedom(from: politicalFreedomDTO) else { return nil }
        self.init(civilRights: civilRights, economy: economy, politicalFreedom: politicalFreedom)
    }
}
