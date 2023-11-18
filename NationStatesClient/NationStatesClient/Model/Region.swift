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
    var factbookHTML: String?
    var founderName: String?
    var foundedTime: Date?
}

struct Region {
    let name: String
    let numberOfNations: Int
    let delegateNationName: String?
    let power: String
    let bannerURL: String
    let flagURL: String?
    var factbookHTML: String?
    var founderName: String?
    var foundedTime: Date?
}

extension Region {
    typealias DTOEquivalent = RegionDTO
    
    init?(from dto: RegionDTO) {
        guard let name = dto.name,
              let numberOfNations = dto.numberOfNations,
              let power = dto.power,
              let bannerURL = dto.bannerURL
        else { return nil }
        self.init(
            name: name,
            numberOfNations: numberOfNations,
            delegateNationName: dto.delegateNationName,
            power: power,
            bannerURL: bannerURL,
            flagURL: dto.flagURL,
            factbookHTML: dto.factbookHTML,
            founderName: dto.founderName,
            foundedTime: dto.foundedTime
        )
    }
}

#if DEBUG
extension Region {
    static let filler = Region(
        name: "Europeia",
        numberOfNations: 1496,
        delegateNationName: "Elest Adra",
        power: "High",
        bannerURL: "https://www.nationstates.net/images/rbanners/uploads/magna_aurea__576205.jpg",
        flagURL: "https://www.nationstates.net/images/flags/uploads/rflags/europeia__37736.png",
        factbookHTML: """
"<span style=\"color: #318120;\"><strong>Welcome to the Republic of Europeia, a beautiful tropical archipelago founded on March 6th, 2007.</strong></span>\r<br><span style=\"color: #03316A;\">Where all nations, regardless of size or government type, have a place among friends!</span>\r<br>\r<br><hr><a href=\"nationstates:page=dispatch/id=1552024\"><strong><span style=\"color: #BB1B1B;\">Start your Journey Here!</span></strong></a> | <a href=\"nationstates:page=un\"><strong><span style=\"color: #bea000;\">Join the World Assembly Here!</span></a> | <a href=\"external:https://forums.europeians.com/index.php\">Check Out Our Forums Here!</a> | <a href=\"nationstates:page=dispatch/id=349445\"><span style=\"color: #03316A;\">Apply for Citizenship Here!</span></a> | <a href=\"external:https://discord.com/invite/nYAwZ7f\"><span style=\"color: #BB1B1B;\">Check Out Our Discord Here!</span></a></strong>\r<br><hr><strong>High Executive Government:</strong>\r<br><strong><span style=\"color: #167D7F;\">President </span></strong><a href=\"/nation=JayDee_II\">JayDee II</a>\r<br><strong><span style=\"color: #03316A;\">Vice President </span></strong><a href=\"/nation=Decacon\">Decacon</a> (Rand)\r<br><hr><span style=\"color: #BB1B1B;\"> We strongly encourage you to</span><a href=\"nationstates:page=dispatch/id=426900\"><strong> join and thrive in the World Assembly</strong></a>!\r<br>\r<br>Increase our regional power and security by <strong>endorsing</strong> <strong>Delegate <a href=\"/nation=UPC\">UPC</a></strong>, <strong>Vice Delegate <a href=\"/nation=Pichtonia\">Pichtonia</a></strong>, and <strong>Regional Security Officers</strong>,<strong> <a href=\"/nation=Primorye_Oblast\">Primorye Oblast</a></strong>, <strong><a href=\"/nation=Le_Libertia\">Le Libertia</a></strong>, <strong><a href=\"/nation=Pland_Adanna\">Pland Adanna</a></strong>, <strong><a href=\"/nation=PhDre\">PhDre</a></strong>, and <strong><a href=\"/nation=Decacon\">Decacon</a></strong>.\r<br>\r<br><span style=\"color: #BB1B1B;\"><strong>EndoCaps:</strong></span>\r<br><span style=\"color: #03316A;\">Citizens endorsing Delegate: <strong>50</strong></span> <strong>|</strong> <span style=\"color: #318120;\">Residents endorsing Delegate: <strong>25</strong></span> <strong>|</strong> <span style=\"color: #bea000;\">Others: <strong>10</strong> </span>\r<br>
""",
        founderName: "Elest Adra",
        foundedTime: Date()
    )
}
#endif
