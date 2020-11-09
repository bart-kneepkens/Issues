//
//  FetchIssuesResult.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 02/11/2020.
//

import Foundation

struct FetchIssuesResult {
    let issues: [Issue]
    let timeLeftForNextIssue: String
    let nextIssueDate: Date
}

struct FetchIssuesResultDTO {
    var issues: [IssueDTO] = []
    var timeLeftForNextIssue: String?
    var nextIssueDate: Date?
}

extension FetchIssuesResult: DTOInitializable {
    typealias DTOEquivalent = FetchIssuesResultDTO
    
    init?(from dto: FetchIssuesResultDTO) {
        guard let timeLeftForNextIssue = dto.timeLeftForNextIssue, let nextIssueDate = dto.nextIssueDate else { return nil }
        self.init(issues: dto.issues.compactMap({ Issue(from: $0) }),
                  timeLeftForNextIssue: timeLeftForNextIssue,
                  nextIssueDate: nextIssueDate)
    }
}
