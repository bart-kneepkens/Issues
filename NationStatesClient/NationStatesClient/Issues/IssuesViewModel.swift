//
//  IssuesViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Combine

class IssuesViewModel: ObservableObject {
    @Published var issues: [Issue] = [
        Issue.filler,
    ]
}
