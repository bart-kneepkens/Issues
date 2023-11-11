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
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        flagView(region: region)
                        Text("\(region.numberOfNations) Nations")
                    }
                    Spacer()
                }
                
                PlainListRow(name: "Regional power", value: region.power)
                WADelegateViewRow(delegateNationName: region.delegateNationName)
                founderViewRow(founderNationName: region.founderName)
                foundedViewRow(foundedTime: region.foundedTime)
            }

            if let factbookHTML = region.factbookHTML {
                Section("Factbook") {
                    FactbookView(viewModel: .init(html: factbookHTML))
                }
            }
            
        } else {
            Section {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    private func flagView(region: Region) -> some View {
        if let flagURL = region.flagURL {
            AsyncImage(url: URL(string: flagURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 64)
            } placeholder: {
                ProgressView()
            }
        } else {
            MissingFlagView()
        }
    }
    
    @ViewBuilder
    private func WADelegateViewRow(delegateNationName: String?) -> some View {
        let title = "WA Delegate"
        
        if let delegateNationName {
            PlainListRow(
                name: title,
                value: AnyView(NationLinkView(viewModel: viewModelFactory.nationLinkViewModel(delegateNationName)))
            )
        } else {
            PlainListRow(name: title, value: "None")
        }
    }
    
    @ViewBuilder
    private func founderViewRow(founderNationName: String?) -> some View {
        let title = "Founder"
        
        if let founderNationName {
            PlainListRow(
                name: title,
                value: AnyView(NationLinkView(viewModel: viewModelFactory.nationLinkViewModel(founderNationName)))
            )
        } else {
            PlainListRow(
                name: title,
                value: "None"
            )
        }
    }
    
    @ViewBuilder
    private func foundedViewRow(foundedTime: Date?) -> some View {
        if let foundedTime {
            PlainListRow(name: "Founded", value: RegionViewModel.dateFormatter.string(from: foundedTime))
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
            // This nifty hack makes sure `didSet` is called
            defer { self.regionName = regionName }
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
        
        static var dateFormatter: DateFormatter = {
            let format = DateFormatter()
            format.timeStyle = .none
            format.dateStyle = .medium
            return format
        }()
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
