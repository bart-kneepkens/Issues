//
//  RegionDetailsView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 21/11/2023.
//

import Foundation
import SwiftUI

struct RegionDetailsView: View {
    
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @EnvironmentObject var navigation: Navigation
    @Environment(\.isPresented) private var isPresented
    @State var sheetNation: NationNamePresentable?
    
    let region: Region
    
    var body: some View {
        Section {
            HStack {
                Spacer()
                VStack(spacing: 10) {
                    Text(region.name).font(.title).bold()
                    flagView(region: region)
                    Text("\(region.numberOfNations) Nations")
                }
                Spacer()
            }
            .sheet(item: $sheetNation) { nationPresentable in
                Wrapped {
                    FetchedNationView(viewModel: viewModelFactory.fetchedNationViewModel(nationPresentable.nationName))
                }
                .presentationDragIndicator(.visible)
            }
            
            PlainListRow(name: "Regional power", value: region.power)
            WADelegateViewRow(delegateNationName: region.delegateNationName)
            founderViewRow(founderNationName: region.founderName)
            foundedViewRow(foundedTime: region.foundedTime)
        }
        .listRowSeparator(.hidden)
        

        if let factbookHTML = region.factbookHTML {
            Section("Factbook") {
                FactbookView(viewModel: .init(html: factbookHTML))
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
                value: delegateNationName,
                action: { presentNation(delegateNationName) }
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
                value: founderNationName,
                action: { presentNation(founderNationName) }
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
            PlainListRow(name: "Founded", value: Self.dateFormatter.string(from: foundedTime))
        }
    }
    
    static var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .medium
        return format
    }()
    
    private func presentNation(_ name: String) {
        if isPresented {
            navigation.push(.nation(name: name))
        } else {
            sheetNation = .init(nationName: name)
        }
    }
    
    struct NationNamePresentable: Identifiable {
        var id: String {
            nationName
        }
        
        let nationName: String
    }
}

#if DEBUG

#Preview {
    List {
        RegionDetailsView(region: .filler)
    }
}
#endif
