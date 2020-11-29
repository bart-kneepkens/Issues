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
    
    var isAwaitingNextIssue: Bool {
        issues.count < 5
    }
    
    var isOk: Bool {
        guard issues.isEmpty else { return true }
        return !timeLeftForNextIssue.isEmpty
    }
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


#if DEBUG
extension FetchIssuesResult {
    static var filler: FetchIssuesResult = .init(issues: [.filler()], timeLeftForNextIssue: "2 hours", nextIssueDate: Date().addingTimeInterval(60 * 60 * 2))
}
#endif
