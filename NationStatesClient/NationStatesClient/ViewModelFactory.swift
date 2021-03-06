//
//  ViewModelFactory.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 10/01/2021.
//

import Foundation

// This doesn't really conform to the Factory pattern, but I can't think of a better name at this time.
// The purpose of this class is to be the one-stop-shop for viewmodel creation and to hold the providers without explicitly passing them everywhere.
class ViewModelFactory {
    private let authenticationContainer: AuthenticationContainer
    
    private let issueProvider: IssueProvider
    private let nationDetailsProvider: NationDetailsProvider
    private let resolutionProvider: ResolutionProvider
    private let authenticationProvider: AuthenticationProvider
    
    init() {
        self.authenticationContainer = AuthenticationContainer()
        
        #if DEBUG
        guard !ViewModelFactory.isRunningInUITest else {
            self.issueProvider = UITestMockProviders.issueProvider
            self.nationDetailsProvider = UITestMockProviders.nationDetailsProvider
            self.resolutionProvider = UITestMockProviders.resolutionProvider
            self.authenticationProvider = UITestMockProviders.authenticationProvider
            return
        }
        #endif
        
        self.issueProvider = APIIssueProvider(container: authenticationContainer)
        self.nationDetailsProvider = APINationDetailsProvider(container: authenticationContainer)
        self.resolutionProvider = APIResolutionProvider(authenticationContainer: authenticationContainer)
        self.authenticationProvider = APIAuthenticationProvider(authenticationContainer: authenticationContainer)
    }
    
    var contentViewModel: ContentViewModel {
        .init(authenticationContainer: authenticationContainer, authenticationProvider: authenticationProvider, nationDetailsProvider: nationDetailsProvider, resolutionProvider: resolutionProvider)
    }
    
    var issuesViewModel: IssuesViewModel {
        .init(provider: issueProvider, authenticationContainer: authenticationContainer)
    }
    
    func issueDetailViewModel(for issue: Issue, with container: IssueContainer) -> IssueDetailViewModel {
        .init(issue, provider: issueProvider, nationName: authenticationContainer.nationName, issueContainer: container)
    }
    
    func issueDetailViewModel(for completedIssue: CompletedIssue) -> IssueDetailViewModel {
        .init(completedIssue: completedIssue, nationName: authenticationContainer.nationName)
    }
    
    var nationViewModel: NationViewModel {
        .init(provider: nationDetailsProvider, authenticationContainer: authenticationContainer)
    }
    
    var worldAssemblyViewModel: WorldAssemblyViewModel {
        .init(authenticationContainer: authenticationContainer, resolutionProvider: resolutionProvider, nationDetailsProvider: nationDetailsProvider)
    }
    
    func signinViewModel(contentViewModel: ContentViewModel) -> SignInViewModel {
        .init(authenticationProvider: authenticationProvider, authenticationContainer: authenticationContainer, contentViewModel: contentViewModel)
    }
    
    func resolutionViewModel(_ resolution: Resolution) -> ResolutionViewModel {
        .init(resolution: resolution, nationDetailsProvider: nationDetailsProvider)
    }
    
    func fetchedNationViewModel(_ nationName: String) -> FetchedNationViewModel {
        .init(nationName, nationDetailsProvider: nationDetailsProvider)
    }
    
    var searchNationViewModel: SearchNationViewModel {
        .init(nationDetailsProvider: nationDetailsProvider)
    }
}

extension ViewModelFactory {
    static var isRunningInUITest: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui_testing")
    }
}
