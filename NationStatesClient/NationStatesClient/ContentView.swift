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
    
    private enum TabBarItem {
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
    
    private func tabBarNavigationView(for item: TabBarItem) -> some View {
        NavigationView {
            switch item {
            case .issues: IssuesView(viewModel: viewModelFactory.issuesViewModel)
            case .worldAssembly: WorldAssemblyView(viewModel: viewModelFactory.worldAssemblyViewModel)
            case .nation: NationView(viewModel: viewModelFactory.nationViewModel)
            case .region: RegionView(viewModel: viewModelFactory.currentRegionViewModel)
            case .more: MoreView(viewModel: viewModelFactory.moreViewModel)
            }
        }
        .navigationViewStyle(.stack)
        .tabItem {
            Text(item.text)
            Image(systemName: item.iconName)
        }
    }
    
    @ViewBuilder private var contents: some View {
        if viewModel.state == ContentViewModel.ContentViewModelState.initial {
            SignInView(viewModel: viewModelFactory.signinViewModel(contentViewModel: self.viewModel))
        } else if viewModel.state == ContentViewModel.ContentViewModelState.signingIn {
            SignInProgressView(error: viewModel.error)
        } else {
            TabView {
                tabBarNavigationView(for: .issues)
                tabBarNavigationView(for: .worldAssembly)
                tabBarNavigationView(for: .nation)
                tabBarNavigationView(for: .region)
                tabBarNavigationView(for: .more)
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
