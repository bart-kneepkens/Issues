//
//  NotificationFeatureInterestViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/02/2025.
//

import Foundation

final class NotificationFeatureInterestViewModel {
    let nationName: String
    private let provider: NotificationFeatureInterestProvider
    private let authenticationContainer: AuthenticationContainer
    
    init(
        provider: NotificationFeatureInterestProvider,
        authenticationContainer: AuthenticationContainer,
        nationDetailsProvider: NationDetailsProvider
    ) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.nationName = nationDetailsProvider.nationDetails.value?.name ?? "late"
    }
    
    func enroll() async {
        guard let pin = authenticationContainer.pin else { return }
        await provider.enroll(nationName: authenticationContainer.nationName, pin: pin)
    }
    
    func disEnroll() async {
        guard let pin = authenticationContainer.pin else { return }
        await provider.disEnroll(nationName: authenticationContainer.nationName, pin: pin)
    }
}
