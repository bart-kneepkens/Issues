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
    private(set) var service: IssuesService
    
    var cancellable: Cancellable?
    
    init(service: IssuesService) {
        self.service = service
        self.cancellable = service.$issues
            .receive(on: DispatchQueue.main)
            .assign(to: \.issues, on: self)
    }
}
