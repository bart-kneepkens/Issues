//
//  IssuesService.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

protocol IssuesService {
    func fetchIssues() -> [Issue]?
    func answer(issue: Issue, option: Option)
}
