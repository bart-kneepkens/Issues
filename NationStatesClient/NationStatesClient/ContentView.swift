//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @ViewBuilder private var contents: some View {
        if viewModel.state == ContentViewModel.ContentViewModelState.initial {
            SignInView(viewModel: viewModelFactory.signinViewModel(contentViewModel: viewModel))
        } else if viewModel.state == ContentViewModel.ContentViewModelState.signingIn {
            SignInProgressView(error: viewModel.error)
        } else {
            TabView {
                IssuesView(viewModel: viewModelFactory.issuesViewModel)
                    .tabItemStyled(with: .issues)
                WorldAssemblyView(viewModel: viewModelFactory.worldAssemblyViewModel)
                    .tabItemStyled(with: .worldAssembly)
                NationView(viewModel: viewModelFactory.nationViewModel)
                    .wrappedInDefaultNavigation()
                    .tabItemStyled(with: .nation)
                RegionView(viewModel: viewModelFactory.currentRegionViewModel)
                    .wrappedInDefaultNavigation()
                    .tabItemStyled(with: .region)
                MoreView(viewModel: viewModelFactory.moreViewModel)
                    .wrappedInDefaultNavigation()
                    .tabItemStyled(with: .more)
            }
        }
    }
    
    var body: some View {
        contents
            .onAppear {
                self.viewModel.onAppear()
            }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel:
                        ContentViewModel(authenticationContainer: .init(), authenticationProvider: MockedAuthenticationProvider(success: true), nationDetailsProvider: MockedNationDetailsProvider(), resolutionProvider: MockedResolutionProvider()))
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
        case worldAssembly
        case nation
        case region
        case more
        
        var text: String {
            switch self {
            case .issues: return "Issues"
            case .worldAssembly: return "World Assembly"
            case .nation: return "Nation"
            case .region: return "Region"
            case .more: return "More"
            }
        }
            
        var iconName: String {
            switch self {
            case .issues: return "newspaper"
            case .worldAssembly: return "camera.filters"
            case .nation: return "flag"
            case .region: return "globe"
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
