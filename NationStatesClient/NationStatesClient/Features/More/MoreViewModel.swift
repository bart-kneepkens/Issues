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
    
    let isEnrolledForNotifications: Bool
    
    private let authenticationContainer: AuthenticationContainer

    
    init(authenticationContainer: AuthenticationContainer, nationDetailsProvider: NationDetailsProvider) {
        self.authenticationContainer = authenticationContainer
        self.isEnrolledForNotifications = NotificationEnrolledNations.names.contains(authenticationContainer.nationName.lowercased())
        nationDetailsProvider.nationDetails.assign(to: &$nation)
    }
    
    var name: String {
        nation?.name ?? authenticationContainer.nationName
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
}

