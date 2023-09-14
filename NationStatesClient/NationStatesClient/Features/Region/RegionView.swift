//
//  RegionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/09/2023.
//

import SwiftUI
import Combine

struct RegionView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @ObservedObject var viewModel: RegionViewModel
    
    var body: some View {
        List {
            listContents
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.refreshRegion()
        }
        .navigationTitle(viewModel.region?.name ?? "")
    }
    
    @ViewBuilder
    private var listContents: some View {
        if let region = viewModel.region {
            Section {        
                PlainListRow(name: "Delegate", value: region.delegateNationName)
                PlainListRow(name: "Number of Nations", value: "\(region.numberOfNations)")
                PlainListRow(name: "Power", value: region.power)
            } header: {
                header
            }
        } else {
            Section {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    private var header: some View {
        if let region = viewModel.region {
            ZStack {
                CachedRemoteImage(url: URL(string: region.bannerURL))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                
                CachedRemoteImage(url: URL(string: region.flagURL))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 64)
            }
            .padding(.bottom)
        }
    }
}

extension RegionView {
    
    final class RegionViewModel: ObservableObject {
        
        @Published var region: Region?
        
        private var regionName: String? {
            didSet {
                Task {
                    await fetchRegion()
                }
            }
        }
        
        private var cancellable: AnyCancellable?
        private let regionDetailsProvider: RegionDetailsProvider
        
        init(nationDetailsProvider: NationDetailsProvider, regionDetailsProvider: RegionDetailsProvider) {
            self.regionDetailsProvider = regionDetailsProvider
            cancellable = nationDetailsProvider
                .nationDetails
                .compactMap({ $0 })
                .map { $0.regionName }
                .assign(to: \.regionName, onWeak: self)
        }
        
        init(regionName: String, regionDetailsProvider: RegionDetailsProvider) {
            self.regionDetailsProvider = regionDetailsProvider
            self.regionName = regionName
        }
        
        func refreshRegion() async {
            guard let regionName else { return }
            let region = await regionDetailsProvider.fetchRegionDetails(with: regionName)
            await updateRegion(with: region)
        }
        
        private func fetchRegion() async {
            guard region == nil else { return }
            await refreshRegion()
        }
        
        @MainActor
        private func updateRegion(with region: Region?) {
            self.region = region
        }
    }
}

#if DEBUG
struct RegionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegionView(viewModel: .init(regionName: "region", regionDetailsProvider: MockedRegionDetailsProvider()))
        }
    }
}
#endif
