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
    private let notificationsProvider: NotificationsProvider

    
    init(
        authenticationContainer: AuthenticationContainer,
        nationDetailsProvider: NationDetailsProvider,
        notificationsProvider: NotificationsProvider
    ) {
        self.authenticationContainer = authenticationContainer
        self.isEnrolledForNotifications = NotificationEnrolledNations.names.contains(authenticationContainer.nationName.lowercased())
        self.notificationsProvider = notificationsProvider
        nationDetailsProvider.nationDetails.assign(to: &$nation)
    }
    
    var name: String {
        nation?.name ?? authenticationContainer.nationName
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
        Task {
            await self.notificationsProvider.unregister()
        }
    }
}

