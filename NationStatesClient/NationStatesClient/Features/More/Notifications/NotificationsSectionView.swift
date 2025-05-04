//
//  NotificationsSectionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 28/03/2025.
//

import SwiftUI

struct NotificationsSectionView: View {
    
    @StateObject
    var viewModel: NotificationsSectionViewModel
    
    private var toggleIsOn: Binding<Bool> {
        .init {
            viewModel.state == .active
        } set: { newValue in
            Task {
                await viewModel.toggleWasUpdated(newValue: newValue)
            }
        }

    }
    
    var body: some View {
        Section {
            serverStatus
            
            switch viewModel.state {
            case .initial, .denied:
                Button {
                    Task {
                        await viewModel.didTap()
                    }
                } label: {
                    Text("Allow Notifications")
                }
                .allowsHitTesting(viewModel.state != .granted)
            case .granted, .active, .inactive:
                notificationsToggleView
            }
        } header: {
            Text("Notifications (experimental)")
        } footer: {
            if viewModel.state == .denied {
                Text("Notifications for Issues have been turned off on this device. Change your notification settings to get updates.")
            }
        }
    }
    
    private var notificationsToggleView: some View {
        HStack {
            Text("Push Notifications")
            Spacer()
            
            if viewModel.state == .granted {
                ProgressView()
            } else {
                Toggle(isOn: toggleIsOn) {}
            }
        }
    }
    
    private var serverStatus: some View {
        HStack {
            Text("Server Status")
            Spacer()
            Circle()
                .fill(serverStatusColor)
                .frame(width: 12, height: 12)
                .animation(.interactiveSpring, value: viewModel.serverIsReachable)
        }
        .task {
            await viewModel.fetchServerStatus()
        }
    }
    
    private var serverStatusColor: Color {
        switch viewModel.serverIsReachable {
        case .none:
                .white
        case .some(let value):
            value ? .green : .red
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        List {
            NotificationsSectionView(
                viewModel: .init(notificationsProvider: MockedNotificationsProvider())
            )
        }
    }
}
#endif
