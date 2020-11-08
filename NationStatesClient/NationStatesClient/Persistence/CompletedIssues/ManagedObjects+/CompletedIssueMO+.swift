//
//  CompletedIssueMO.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension CompletedIssueMO {
    convenience init(with completedIssue: CompletedIssue, context: NSManagedObjectContext) {
        self.init(context: context)
        self.issue = IssueMO(with: completedIssue.issue, context: context)
        self.result = AnsweredIssueResultMO(with: completedIssue.result, context: context)
    }
    
    var completedIssue: CompletedIssue? {
        guard let issue = self.issue?.issue, let result = self.result?.answeredIssueResult else { return nil }
        return CompletedIssue(issue: issue, result: result)
    }
}
