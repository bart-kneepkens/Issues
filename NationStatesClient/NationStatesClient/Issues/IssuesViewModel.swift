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
    @Published var fetchingIssues = false
    private(set) var service: IssuesService
    
    var cancellables: [Cancellable?] = []
    
    init(service: IssuesService) {
        self.service = service
        self.cancellables.append(service.$issues
            .receive(on: DispatchQueue.main)
            .assign(to: \.issues, on: self))
        
        self.cancellables.append(service.$fetchingIssues
                                    .receive(on: DispatchQueue.main)
                                    .assign(to: \.fetchingIssues, on: self))
        
    }
}
