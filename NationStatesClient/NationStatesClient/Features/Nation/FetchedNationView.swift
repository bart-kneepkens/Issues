//
//  FetchedNationView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 12/01/2021.
//

import SwiftUI
import Combine

class FetchedNationViewModel: ObservableObject {
    enum State: Equatable {
        static func == (lhs: FetchedNationViewModel.State, rhs: FetchedNationViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial): return true
            case (.loading, .loading): return true
            case (.loaded(let l), .loaded(let r)): return l.name == r.name
            case (.error(let l), .error(let r)): return l.localizedDescription == r.localizedDescription
            default: return false
            }
        }
        
        case initial
        case loading(String)
        case loaded(Nation)
        case error(APIError)
    }
    
    @Published var state: State = .initial
    private let nationName: String
    private let nationDetailsProvider: NationDetailsProvider
    private var cancellable: Cancellable?
    
    init(_ nationName: String, nationDetailsProvider: NationDetailsProvider) {
        self.nationName = nationName
        self.nationDetailsProvider = nationDetailsProvider
    }
    
    @MainActor
    func startFetch() async {
        guard self.state == .initial else { return }
        self.state = .loading(nationName)
        
        do {
            if let nation = try await nationDetailsProvider.fetchNationDetails(for: nationName) {
                self.state = .loaded(nation)
            }
        } catch {
            self.state = .error(error.asAPIError)
        }
    }
}

struct FetchedNationView: View {
    @StateObject var viewModel: FetchedNationViewModel
    
    @ViewBuilder private var contents: some View {
        switch viewModel.state {
        case .loaded(let nation):
            NationDetailsView(nation: nation)
        case .error(let apiError):
            ErrorView(error: apiError, onPress: nil)
        default:
            ProgressView()
        }
    }
    
    var body: some View {
        List {
            contents
        }
        .listStyle(.insetGrouped)
        .onAppear {
            Task {
                await viewModel.startFetch()
            }
        }
    }
}

#if DEBUG
struct FetchedNationView_Previews: PreviewProvider {
    static var previews: some View {
        FetchedNationView(viewModel: .init("", nationDetailsProvider: MockedNationDetailsProvider()))
    }
}
#endif
