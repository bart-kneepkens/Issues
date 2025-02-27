//
//  MoreView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 26/05/2022.
//

import SwiftUI

struct MoreView: View {
    
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @StateObject var viewModel: MoreViewModel
    @ObservedObject var badgeViewModel: MoreBadgeViewModel
    
    var body: some View {
        List {
            if viewModel.isEnrolledForNotifications {
                notificationEnrolledStatusView
            }
            contactSection
            accountSection
        }
        .navigationTitle("More")
        .onAppear {
            viewModelFactory.moreBadgeViewModel.clearBadge()
        }
    }
    
    @ViewBuilder
    private var notificationEnrolledStatusView: some View {
        Section("From the developer") {
            Text("\(viewModel.name) is enrolled for the upcoming issues notification feature. Please hang on while I get things ready!")
        }
    }
    
    private var contactSection: some View {
        Section {
            NavigationLink {
                FeedbackIntroductionView()
            } label: {
                Label("Share Feedback", systemImage: "envelope")
            }
        } header: {
            Text("Feedback")
        }
    }
    
    private var accountSection: some View {
        Section(header: Text("Account")) {
            Button("Sign out \(self.viewModel.name)") {
                DispatchQueue.main.async {
                    self.viewModel.signOut()
                }
            }.foregroundColor(.red)
        }
    }
}

#if DEBUG
#Preview {
    MoreView(
        viewModel: .init(authenticationContainer: MockedAuthenticationContainer(), nationDetailsProvider: MockedNationDetailsProvider()),
        badgeViewModel: .init(notificationFeatureInterestProvider: MockedNotificationFeatureInterestProvider())
    )
}
#endif
