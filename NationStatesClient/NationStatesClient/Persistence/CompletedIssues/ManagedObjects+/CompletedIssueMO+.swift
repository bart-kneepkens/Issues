//
//  CompletedIssueMO.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension CompletedIssueMO: ModelConfigurable {
    typealias ModelEquivalent = CompletedIssue
    
    func configure(with model: CompletedIssue, using context: NSManagedObjectContext) {
        self.issue = IssueMO(with: model.issue, context: context)
        self.result = AnsweredIssueResultMO(with: model.result, context: context)
    }
    
    convenience init(with completedIssue: CompletedIssue, context: NSManagedObjectContext) {
        self.init(context: context)
        self.configure(with: completedIssue, using: context)
    }
}

extension CompletedIssueMO {
    var completedIssue: CompletedIssue? {
        guard let issueDTO = self.issue?.dto, let resultDTO = self.result?.dto else { return nil }
        guard let issue = Issue(from: issueDTO), let result = AnsweredIssueResult(from: resultDTO) else { return nil }
        return CompletedIssue(issue: issue, result: result)
    }
}
