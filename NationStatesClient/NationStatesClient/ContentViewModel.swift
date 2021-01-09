//
//  ContentViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/11/2020.
//

import Foundation
import Combine
import WidgetKit

class ContentViewModel: ObservableObject {
    enum ContentViewModelState {
        case signingIn
        case signedIn
        case initial
    }
    
    @Published var state: ContentViewModelState = .initial {
        didSet {
            if state == .signedIn {
                WidgetCenter.shared.reloadAllTimelines()
                self.nationDetailsProvider.fetchCurrentNationDetails()
                self.resolutionProvider.fetchResolutions()
            }
        }
    }
    @Published var error: APIError?
    
    private let issueProvider: IssueProvider
    private let authenticationProvider: AuthenticationProvider
    private let nationDetailsProvider: NationDetailsProvider
    private let resolutionProvider: ResolutionProvider
    
    private let authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable]? = []
    
    init() {
        self.authenticationContainer = AuthenticationContainer()
        self.issueProvider = APIIssueProvider(container: self.authenticationContainer)
        self.authenticationProvider = APIAuthenticationProvider(authenticationContainer: self.authenticationContainer)

        self.nationDetailsProvider = APINationDetailsProvider(container: self.authenticationContainer)
        self.resolutionProvider = APIResolutionProvider(authenticationContainer: self.authenticationContainer)
        
        self.cancellables?.append(self.authenticationContainer.$hasSignedOut
                                    .receive(on: DispatchQueue.main)
                                    .sink { signedOut in
                                        if signedOut {
                                            self.state = .initial
                                            WidgetCenter.shared.reloadAllTimelines()
                                        }
                                    })
    }
    
    func onAppear() {
        guard self.authenticationContainer.canPerformSilentLogin else { return }
        
        self.state = .signingIn
        
        // Attempt a silent log in
        self.cancellables?.append(
            self.authenticationProvider.authenticate(authenticationContainer: self.authenticationContainer)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    switch error {
                    case .notConnected: fallthrough
                    case .rateExceeded: fallthrough
                    case .timedOut:
                        self.error = error
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                            self.onAppear()
                        }
                        return
                    default:
                        self.state = .initial
                    }
                default: break
                }
            }, receiveValue: { success in
                if success {
                    self.state = .signedIn
                }
            })
        )
        
    }
}

extension ContentViewModel {
    var issuesViewModel: IssuesViewModel {
        .init(provider: self.issueProvider, authenticationContainer: self.authenticationContainer)
    }
    
    var signInViewModel: SignInViewModel {
        .init(authenticationProvider: self.authenticationProvider,
                               authenticationContainer: self.authenticationContainer,
                               contentViewModel: self)
    }
    
    var worldAssemblyViewModel: WorldAssemblyViewModel {
        .init(authenticationContainer: self.authenticationContainer,
                     resolutionProvider: self.resolutionProvider,
                     nationDetailsProvider: self.nationDetailsProvider)
    }
    
    var nationViewModel: NationViewModel {
        .init(provider: self.nationDetailsProvider, authenticationContainer: self.authenticationContainer)
    }
}
