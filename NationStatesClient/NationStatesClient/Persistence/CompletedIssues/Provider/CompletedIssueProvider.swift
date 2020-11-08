//
//  CompletedIssueProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/11/2020.
//

import Foundation
import Combine

protocol CompletedIssueProvider {
    func fetchCompletedIssues() -> AnyPublisher<[CompletedIssue], Error>
    func storeCompletedIssue(_ completed: CompletedIssue)
}
