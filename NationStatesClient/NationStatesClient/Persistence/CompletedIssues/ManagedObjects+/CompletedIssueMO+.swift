//
//  CompletedIssueMO.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension CompletedIssueMO{
    func configure(with completedIssue: CompletedIssue, context: NSManagedObjectContext) {
        let issue = IssueMO(context: context)
        issue.configure(with: completedIssue.issue, context: context)
        self.issue = issue
        let result = AnsweredIssueResultMO(context: context)
        result.configure(with: completedIssue.result, context: context)
        self.result = result
    }
    
    var completedIssue: CompletedIssue {
        return CompletedIssue(issue: self.issue?.issue ?? .filler, result: .filler)
    }
}
