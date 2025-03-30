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
    
    var body: some View {
        Section {
            Toggle(isOn: $viewModel.notificationsEnabled, label: {
                Text("Enable push notifications")
            })
            
            serverStatus
        } header: {
            Text("Notifications (experimental)")
        }
    }
    
    private var serverStatus: some View {
        HStack {
            Text("Server status")
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
    List {
        NotificationsSectionView(
            viewModel: .init(notificationsProvider: MockedNotificationsProvider())
        )
    }
}
#endif
