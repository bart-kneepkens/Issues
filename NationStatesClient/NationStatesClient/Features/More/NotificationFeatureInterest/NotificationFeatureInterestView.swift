//
//  NotificationFeatureInterestView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/02/2025.
//

import SwiftUI

struct NotificationFeatureInterestView: View {
    
    @AppStorage("notification-feature-interest") private var isToggleOn: Bool = false
    
    let viewModel: NotificationFeatureInterestViewModel
    
    var body: some View {
        Section("From the developer") {
            Text("Would you be interested in receiving a notification whenever a new issue has appeared? \nBy enrolling, your nation can be selected for a limited trial in future updates of the app.")
            
            Text("Note: only your nation name and interest will be recorded, and the trial will run for this nation only.")
                .font(.caption)

            Toggle(isOn: $isToggleOn, label: {
                Text("Enroll \(viewModel.nationName)")
            })
        }
        .onChange(of: isToggleOn, perform: { value in
            if value {
                Task {
                    await viewModel.enroll()
                }
            } else {
                Task {
                    await viewModel.disEnroll()
                }
            }
        })
    }
}

#if DEBUG

#Preview {
    List {
        NotificationFeatureInterestView(viewModel: .init(provider: MockedNotificationFeatureInterestProvider(), authenticationContainer: .init(), nationDetailsProvider: MockedNationDetailsProvider()))
    }
    .listStyle(.insetGrouped)
}

#endif
