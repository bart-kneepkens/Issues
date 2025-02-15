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
            if badgeViewModel.showsNotificationFeatureInterestElements {
                interestSection
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
    private var interestSection: some View {
        NotificationFeatureInterestView(viewModel: viewModelFactory.notificaitonFeatureInterestSectionViewModel)
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
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(viewModel: .init(nation: .filler), badgeViewModel: .init(notificationFeatureInterestProvider: MockedNotificationFeatureInterestProvider()))
    }
}
#endif
