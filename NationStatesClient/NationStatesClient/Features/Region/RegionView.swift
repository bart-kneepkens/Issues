//
//  RegionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/09/2023.
//

import SwiftUI
import Combine


fileprivate extension Region {
    static var formatter: DateFormatter = {
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .medium
        return format
    }()
    
    var foundedDateString: String {
        Self.formatter.string(from: foundedTime)
    }
}

struct RegionView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @ObservedObject var viewModel: RegionViewModel
    
    @State var factbookHeight: CGFloat = .zero
    
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
                
                PlainListRow(name: "WA Delegate", value: region.delegateNationName)
                PlainListRow(name: "Regional power", value: region.power)
                PlainListRow(name: "Founder", value: region.founderName ?? "None")
                PlainListRow(name: "Founded", value: region.foundedDateString)
            }

            Section("Factbook") {
                InlineHTMLTextWebView(html: region.factbookHTML, dynamicHeight: $factbookHeight)
                    .onLinkTap { link in
                        print(link) // TODO: Something useful
                    }
                    .frame(height: factbookHeight)
                    .listRowInsets(.init(top: 8, leading: 8, bottom:8, trailing: 8))
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
