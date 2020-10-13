//
//  IssuesViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

class IssuesViewModel: ObservableObject {
    @Published var issues: [Issue] = []
    
    var cancellable: Cancellable?
    
    init() {
        self.cancellable = IssuesService.shared.$issues
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { serviceIssues in
                self.issues = serviceIssues
            })
        
        IssuesService.shared.fetchIssues()
    }
}
