//
//  IssuesView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI
import Combine
import UIKit

fileprivate enum DisplayMode: String {
    case issues = "Issues"
    case pastIssues = "Past Issues"
}

struct IssuesView: View {
    @StateObject var viewModel: IssuesViewModel
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @EnvironmentObject var deeplinkHandler: DeeplinkHandler
    
    @State var selectedIssueOverlay: Issue?
    
    @State private var displayMode : DisplayMode = .issues
    @State var showsWorldAssembly = false
    
    @ViewBuilder private var content: some View {
        
        if viewModel.isFetchingIssues {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack {
                HStack {
                    toolbarTitle
                    Button {
                        showsWorldAssembly.toggle()
                    } label: {
                        if #available(iOS 26.0, *) {
                            Image(systemName: "globe.europe.africa")
                                .font(.system(size: 21))
                                .tint(.primary)
                                .padding(10)
                                .glassEffect()
                        } else {
                            // Fallback on earlier versions
                            Image(systemName: "globe.europe.africa")
                                .font(.system(size: 21))
                                .tint(.primary)
                                .padding(10)
                        }
                    }
                }
                switch displayMode {
                case .issues:
                    cards
                case .pastIssues:
                    PastIssuesView(viewModelFactory: viewModelFactory, completedIssues: viewModel.completedIssues)
                }
            }
        }
    }
    
    @ViewBuilder
    var toolbarTitle: some View {
        Menu {
            Button {
                displayMode = .issues
            } label: {
                Label("Issues", systemImage: "tray.full")
                    .labelStyle(.titleAndIcon)
            }
            
            Button {
                displayMode = .pastIssues
            } label: {
                Label("Past Issues", systemImage: "clock.arrow.circlepath")
                    .labelStyle(.titleAndIcon)
            }
            
        } label: {
            HStack {
                Text(displayMode.rawValue)
                    .font(.largeTitle)
                    .bold()
                    .tint(.primary)
                
                Image(systemName: "chevron.up.chevron.down")
                    .fontWeight(.medium)
                    .tint(.primary)
                    .padding(.top, 8)
                
                Spacer()
            }
        }
        
    }

    var body: some View {
        content
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $viewModel.visibleIssueId)
            .safeAreaPadding()
            .onAppear {
                viewModel.updateIssues() // Throttled accordingly in VM
            }
            .onOpenURL { url in
                deeplinkHandler.handle(url: url)
            }
            .task(id: deeplinkHandler.activeLink) {
                guard let link = deeplinkHandler.activeLink else { return }
                do {
                    try viewModel.resolveIssueDeeplink(link: link)
                } catch {
                    if case DeeplinkError.needsToBeDeferred = error {
                        viewModel.deferredLink = link
                    }
                }
                
                deeplinkHandler.activeLink = nil
            }
            .sheet(item: $selectedIssueOverlay) { issue in
                IssueDetailView(
                    viewModel: viewModelFactory.issueDetailViewModel(
                        for: issue,
                        with: viewModel
                    )
                )
                .presentationDetents([.large])
            }
            .fullScreenCover(isPresented: $showsWorldAssembly, content: {
                WorldAssemblyView(
                    viewModel: viewModelFactory.worldAssemblyViewModel
                )
            })
            .background(background)
            .toolbar(.hidden)
    }
    
    @ViewBuilder private var background: some View {
        Color(UIColor.systemGroupedBackground)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var cards: some View {
        if viewModel.issues.isEmpty {
            emptyView
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.issues, id: \.id) { issue in
                        Button {
                            selectedIssueOverlay = issue
                        } label: {
                            IssueCardView(
                                viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: viewModel)
                            )
                            .containerRelativeFrame(.horizontal)
                            .id(issue.id)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .scrollTargetLayout()
            }
        }
    }
    
    @ViewBuilder
    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(.largeTitle))
            
            Text("No issues")
                .bold()
                .font(.title3)
            
            Text("Go on and enjoy your day, great Leader!")
            
            Spacer()
            if let result = viewModel.fetchIssuesResult {
                Label("Next issue: \(result.timeLeftForNextIssue)", systemImage: "clock")
            }
        }
    }
    
    @ViewBuilder private var fetchingIndicator: some View {
        if self.viewModel.isFetchingIssues {
            Section {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder private var footerView: some View {
        if let error = self.viewModel.error {
            ErrorView(error: error) {
                switch error {
                case .unauthorized:
                    self.viewModel.signOut()
                default: break
                }
            }
        } else if let result = self.viewModel.fetchIssuesResult, self.viewModel.issues.count != 5 {
                Text("Next issue \(result.timeLeftForNextIssue)")
        }
    }
}

#if DEBUG
#Preview {
    TabView {
        IssuesView(viewModel:
                    IssuesViewModel(
                        provider: MockedIssueProvider(
                            issues: [.filler(), .filler(1), .filler(2)]
                        ),
                        completedIssueProvider: MockedCompletedIssueProvider(),
                        authenticationContainer: MockedAuthenticationContainer()
                    )
        )
        .environmentObject(DeeplinkHandler())
        .tabItem {
            Label {
                Text("gg")
            } icon: {
                Image(systemName: "cross")
            }
            
        }
    }
}

#Preview("No new issues") {
    TabView {
        
        IssuesView(viewModel:
                    IssuesViewModel(
                        provider: MockedIssueProvider(
                            issues: []
                        ),
                        completedIssueProvider: MockedCompletedIssueProvider(),
                        authenticationContainer: MockedAuthenticationContainer()
                    )
        )
        .environmentObject(DeeplinkHandler())
        .tabItem {
            Label {
                Text("gg")
            } icon: {
                Image(systemName: "cross")
            }
        }
    }
}
#endif
