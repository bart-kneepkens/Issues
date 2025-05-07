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
                NotificationsSectionView(
                    viewModel: viewModelFactory.notificationsSectionViewModel
                )
            }
            contactSection
            accountSection
        }
        .navigationTitle("More")
        .onAppear {
            viewModelFactory.moreBadgeViewModel.clearBadge()
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
        viewModel: .init(authenticationContainer: MockedAuthenticationContainer(), nationDetailsProvider: MockedNationDetailsProvider(), notificationsProvider: MockedNotificationsProvider()),
        badgeViewModel: .init(notificationsProvider: MockedNotificationsProvider())
    )
}
#endif
