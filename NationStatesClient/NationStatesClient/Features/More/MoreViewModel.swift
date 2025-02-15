//
//  MoreViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 26/05/2022.
//

import Foundation
import Combine

class MoreViewModel: ObservableObject {
    @Published var nation: Nation?
    
    private let authenticationContainer: AuthenticationContainer
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
    }
    
    var name: String {
        authenticationContainer.nationName
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
}

#if DEBUG
extension MoreViewModel {
    convenience init(nation: Nation) {
        self.init(authenticationContainer: .init())
        self.nation = nation
    }
}
#endif
