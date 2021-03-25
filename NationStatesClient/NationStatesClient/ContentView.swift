//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

private struct ViewModelFactoryEnvironmentKey: EnvironmentKey {
    static var defaultValue: ViewModelFactory = ViewModelFactory()
}

extension EnvironmentValues {
    var viewModelFactory: ViewModelFactory {
        get { self[ViewModelFactoryEnvironmentKey.self] }
        set { self[ViewModelFactoryEnvironmentKey.self] = newValue }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    private enum TabBarItem {
        case issues
        case worldAssembly
        case nation
        
        var text: String {
            switch self {
            case .issues: return "Issues"
            case .worldAssembly: return "World Assembly"
            case .nation: return "Nation"
            }
        }
            
        var iconName: String {
            switch self {
            case .issues: return "newspaper"
            case .worldAssembly: return "camera.filters"
            case .nation: return "flag"
            }
        }
    }
    
    private func tabBarNavigationView(for item: TabBarItem) -> some View {
        NavigationView {
            switch item {
            case .issues: IssuesView(viewModel: viewModelFactory.issuesViewModel)
            case .worldAssembly: WorldAssemblyView(viewModel: viewModelFactory.worldAssemblyViewModel)
            case .nation: NationView(viewModel: viewModelFactory.nationViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Text(item.text)
            Image(systemName: item.iconName)
        }
    }
    
    @ViewBuilder private var contents: some View {
        if viewModel.state == ContentViewModel.ContentViewModelState.initial {
            SignInView(viewModel: viewModelFactory.signinViewModel(viewModel))
        } else if viewModel.state == ContentViewModel.ContentViewModelState.signingIn {
            SignInProgressView(error: viewModel.error)
        } else {
            TabView {
                tabBarNavigationView(for: .issues)
                tabBarNavigationView(for: .worldAssembly)
                tabBarNavigationView(for: .nation)
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
        ContentView(viewModel: ContentViewModel(authenticationContainer: .init(), authenticationProvider: MockedAuthenticationProvider(success: true), nationDetailsProvider: MockedNationDetailsProvider(), resolutionProvider: MockedResolutionProvider()))
    }
}
#endif
