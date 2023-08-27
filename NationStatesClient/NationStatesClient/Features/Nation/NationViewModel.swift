//
//  NationViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/11/2020.
//

import Foundation
import Combine

class NationViewModel: ObservableObject {
    @Published var nation: Nation?
    
    private let authenticationContainer: AuthenticationContainer
    private let provider: NationDetailsProvider
    private var cancellables: [Cancellable]? = []
    
    init(provider: NationDetailsProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.cancellables?.append(self.provider.nationDetails.assign(to: \.nation, on: self))
    }
    
    var name: String {
        authenticationContainer.nationName
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
    
    func refresh() {
        provider.fetchCurrentNationDetails()
    }
}


#if DEBUG
extension NationViewModel {
    convenience init(nation: Nation, name: String) {
        self.init(provider: MockedNationDetailsProvider(), authenticationContainer: .init())
        self.nation = nation
    }
}
#endif
