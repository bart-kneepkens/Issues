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

extension FetchIssuesResult {
    init(_ dto: FetchIssuesResultDTO) {
        self.issues = dto.issues.map({ Issue($0) })
        self.timeLeftForNextIssue = dto.timeLeftForNextIssue ?? ""
        self.nextIssueDate = dto.nextIssueDate ?? Date()
    }
}

struct FetchIssuesResultDTO {
    var issues: [IssueDTO] = []
    var timeLeftForNextIssue: String?
    var nextIssueDate: Date?
}
