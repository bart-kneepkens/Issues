//
//  Region.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/09/2023.
//

import Foundation

struct RegionDTO: Equatable {
    var name: String?
    var numberOfNations: Int?
    var delegateNationName: String?
    var power: String?
    var bannerURL: String?
    var flagURL: String?
}

struct Region {
    let name: String
    let numberOfNations: Int
    let delegateNationName: String
    let power: String
    let bannerURL: String
    let flagURL: String
}

extension Region {
    typealias DTOEquivalent = RegionDTO
    
    init?(from dto: RegionDTO) {
        guard let name = dto.name,
              let numberOfNations = dto.numberOfNations,
              let delegateNationName = dto.delegateNationName,
              let power = dto.power,
              let bannerURL = dto.bannerURL,
              let flagURL = dto.flagURL
        else { return nil }
        self.init(name: name, numberOfNations: numberOfNations, delegateNationName: delegateNationName, power: power, bannerURL: bannerURL, flagURL: flagURL)
    }
}

#if DEBUG
extension Region {
    static let filler = Region(
        name: "Filler Region",
        numberOfNations: 123,
        delegateNationName: "Elest Adra",
        power: "High",
        bannerURL: "https://www.nationstates.net/images/rbanners/uploads/magna_aurea__576205.jpg",
        flagURL: "https://www.nationstates.net/images/flags/Djibouti.png"
    )
}
#endif
