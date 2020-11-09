//
//  CompletedIssue.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation

struct CompletedIssue {
    var issue: Issue
    var result: AnsweredIssueResult
}

extension CompletedIssue: DTOInitializable {
    typealias DTOEquivalent = CompletedIssueDTO
    
    init?(from dto: CompletedIssueDTO) {
        guard let issueDTO = dto.issue, let resultDTO = dto.result else { return nil }
        guard let issue = Issue(from: issueDTO), let result = AnsweredIssueResult(from: resultDTO) else { return nil }
        self.init(issue: issue, result: result)
    }
}

struct CompletedIssueDTO {
    var issue: IssueDTO?
    var result: AnsweredIssueResultDTO?
}
