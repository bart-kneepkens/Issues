//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    @ObservedObject var moreBadgeViewModel: MoreBadgeViewModel
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @EnvironmentObject var deeplinkHandler: DeeplinkHandler
    
    @ViewBuilder private var contents: some View {
        if viewModel.state == ContentViewModel.ContentViewModelState.initial {
            SignInView(viewModel: viewModelFactory.signinViewModel(contentViewModel: viewModel))
        } else {
            TabView {
                Tab("Issues", systemImage: "newspaper") {
                    if viewModel.state == .signingIn {
                        SignInProgressView(error: viewModel.error)
                    } else {
                        IssuesView(viewModel: viewModelFactory.issuesViewModel)
                    }
                }
                
                Tab("Nation", systemImage: "building.columns") {
                    NationView(viewModel: viewModelFactory.nationViewModel)
                        .wrappedInDefaultNavigation()
                }
                Tab("Region", systemImage: "map") {
                    RegionView(viewModel: viewModelFactory.currentRegionViewModel)
                        .wrappedInDefaultNavigation()
                }
                
                Tab("More", systemImage: "ellipsis") {
                    MoreView(
                        viewModel: viewModelFactory.moreViewModel,
                        badgeViewModel: moreBadgeViewModel
                    )
                    .wrappedInDefaultNavigation()
                }
                .badge(moreTabBadge)
            }
            .allowsHitTesting(viewModel.state == .signedIn)
        }
    }
    
    var body: some View {
        contents
            .onAppear {
                self.viewModel.onAppear()
            }
    }
    
    private var moreTabBadge: Text? {
        guard let badgeValue = moreBadgeViewModel.badgeValue else {
            return nil
        }
        return Text(badgeValue)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel:
                        ContentViewModel(authenticationContainer: .init(), authenticationProvider: MockedAuthenticationProvider(success: true), nationDetailsProvider: MockedNationDetailsProvider(), resolutionProvider: MockedResolutionProvider()),
                    moreBadgeViewModel:
                        MoreBadgeViewModel(notificationsProvider: MockedNotificationsProvider(), authenticationContainer: .init())
        )
    }
}
#endif

// MARK: View Modifiers

private struct WrappedInNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        NavigationStack {
            content
        }
    }
}

extension View {
    /// Wraps the view in a default NavigationStack without a bound path
    func wrappedInDefaultNavigation() -> some View {
        modifier(WrappedInNavigationModifier())
    }
}

private struct TabItemStyled: ViewModifier {
    enum TabBarItem {
        case issues
        case nation
        case more
        
        var text: String {
            switch self {
            case .issues: return "Issues"
            case .nation: return "Nation"
            case .more: return "More"
            }
        }
            
        var iconName: String {
            switch self {
            case .issues: return "newspaper"
            case .nation: return "building.columns"
            case .more: return "ellipsis"
            }
        }
    }
    
    let item: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                Text(item.text)
                Image(systemName: item.iconName)
            }
    }
}

private extension View {
    /// Styles the view's tab item according to the provided TabBarItem case.
    func tabItemStyled(with item: TabItemStyled.TabBarItem) -> some View {
        modifier(TabItemStyled(item: item))
    }
}
