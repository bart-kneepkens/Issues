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
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
        self.provider = APINationDetailsProvider(container: authenticationContainer)
        self.name = authenticationContainer.nationName
    }
    
    var name: String
    
    @Published var nation: Nation?

    func loadDetails() {
        self.cancellables?.append(
            self.provider.fetchDetails()
                .receive(on: DispatchQueue.main)
                .catch({ error -> AnyPublisher<Nation?, Never> in
                    return Just(nil).eraseToAnyPublisher()
                })
                .assign(to: \.nation, on: self)
        )
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
}


#if DEBUG
extension NationViewModel {
    convenience init(nation: Nation, name: String) {
        self.init(authenticationContainer: .init())
        
        self.name = name
        self.nation = nation
    }
}
#endif
