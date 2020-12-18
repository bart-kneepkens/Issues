//
//  NationViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/11/2020.
//

import Foundation
import Combine

class NationViewModel: ObservableObject {
    private let authenticationContainer: AuthenticationContainer
    private let provider: NationDetailsProvider
    private var cancellables: [Cancellable]? = []
    
    init(provider: NationDetailsProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.name = authenticationContainer.nationName
        self.nation = provider.nationDetails
    }
    
    var name: String
    
    @Published var nation: Nation?
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
}


#if DEBUG
extension NationViewModel {
    convenience init(nation: Nation, name: String) {
        self.init(provider: MockedNationDetailsProvider(), authenticationContainer: .init())
        
        self.name = name
        self.nation = nation
    }
}
#endif
