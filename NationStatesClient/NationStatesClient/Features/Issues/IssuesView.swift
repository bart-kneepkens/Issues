//
//  IssuesView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI
import Combine
import UIKit

struct IssuesView: View {
    @StateObject var viewModel: IssuesViewModel
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @EnvironmentObject var deeplinkHandler: DeeplinkHandler
    
    @State var selectedIssueOverlay: Issue?
    
    @ViewBuilder private var content: some View {
        if viewModel.issues.isEmpty {
            background
        } else {
            cards
        }
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            content
                .background(
                   background
                )
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $viewModel.visibleIssueId)
            .safeAreaPadding(.horizontal, 20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            NavigationLink {
                                PastIssuesView(viewModelFactory: viewModelFactory, completedIssues: viewModel.completedIssues)
                            } label: {
                                Label("Past Issues", systemImage: "clock.arrow.circlepath")
                                    .labelStyle(.titleAndIcon)
                            }

                        } label: {
                            HStack {
                                Text("Issues")
                                    .font(.largeTitle)
                                    .bold()
                                    .tint(.primary)
                                Image(systemName: "chevron.down")
                                    .fontWeight(.medium)
                                    .tint(.primary)
                                    .padding(.top, 8)
                                
                                Spacer()
                            }
                        }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    nationButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "globe")
                        .onTapGesture {
                            Task {
                                try! await viewModel.refreshIssuesManually()
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.large)
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
            .fullScreenCover(item: $selectedIssueOverlay) { issue in
                IssueDetailView(viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: self.viewModel))
                    .presentationBackground(.clear)
            }
            .background(background)
            
        }
    }
    
    @ViewBuilder private var background: some View {
        Color(UIColor.systemGroupedBackground)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var cards: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.issues, id: \.id) { issue in
                    Button(action: {
                        
                        var transaction = Transaction()
                        transaction.disablesAnimations = true

                        withTransaction(transaction) {
                            selectedIssueOverlay = issue
                        }
                        
                    }) {
                        IssueCardView(
                            viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: viewModel)
                        )
                        .containerRelativeFrame(.horizontal)
                        .safeAreaPadding(.vertical, 20)
                        .id(issue.id)
                        .shadow(radius: 4)
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollTargetLayout()
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
    
    @ViewBuilder private var nationButton: some View {
        NavigationLink {
            NationView(viewModel: viewModelFactory.nationViewModel)
        } label: {
            CachedRemoteImage(url:  URL(string: viewModelFactory.nationViewModel.nation?.flagURL ?? ""))
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(lineWidth: 4).foregroundStyle(Color.accentColor)
                }
        }
    }
}

#if DEBUG
struct IssuesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TabView {
                IssuesView(viewModel:
                            IssuesViewModel(provider: MockedIssueProvider(issues: [.filler(), .filler(1), .filler(2)]), completedIssueProvider: MockedCompletedIssueProvider(), authenticationContainer:.init())
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
    }
}
#endif
