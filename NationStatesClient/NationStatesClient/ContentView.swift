//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
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
            case .issues: IssuesView(viewModel: self.viewModel.issuesViewModel)
            case .worldAssembly: WorldAssemblyView(viewModel: self.viewModel.worldAssemblyViewModel)
            case .nation: NationView(viewModel: viewModel.nationViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Text(item.text)
            Image(systemName: item.iconName)
        }
    }
    
    var body: some View {
        Group {
            if viewModel.state == ContentViewModel.ContentViewModelState.initial {
                SignInView(viewModel: self.viewModel.signInViewModel)
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
        .onAppear {
            self.viewModel.onAppear()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
