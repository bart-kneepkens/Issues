//
//  NationView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/10/2020.
//

import SwiftUI

struct NationDetailsView: View {
    let nation: Nation
    
    @EnvironmentObject var navigation: Navigation
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @State var showsRegionSheet = false
    
    @Environment(\.isPresented) private var isPresented
    
    var body: some View {
        Section {
            VStack(alignment: .center, spacing: 10) {
                flagView(nation.flagURL)
                nameView(fullName: nation.fullName, name: nation.name)
                categoryView(nation.category)
                mottoView(nation.motto)
            }
        }
        
        generalStatisticsView(nation.populationMillions, currency: nation.currency, animal:nation.animal)
        
        freedomView(nation.freedoms)
        
        regionView(nation.regionName, influence: nation.regionInfluence)
    }
    
    @ViewBuilder private func nameView(fullName: String, name: String) -> some View {
        let prefix = fullName.replacingOccurrences(of: name, with: "")
        Text(prefix)
        Text(name).font(.title).bold()
    }
    
    @ViewBuilder private func categoryView(_ category: String) -> some View {
        Text(category)
            .tracking(8)
            .opacity(0.8)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder private func mottoView(_ motto: String) -> some View {
        Text("\"\(motto)\"").italic()
    }
    
    @ViewBuilder private func flagView(_ path: String) -> some View {
        let url = URL(string: path)
        HStack {
            Spacer()
            CachedRemoteImage(url: url)
                .aspectRatio(contentMode: .fit)
                .frame(height: 64)
            Spacer()
        }
    }
    
    @ViewBuilder private func generalStatisticsView(_ populationMillions: Int, currency: String, animal: String) -> some View {
        let populationString = populationMillions >= 1000 ? String(format: "%.3f billion", Double(populationMillions)/Double(1000)) : "\(populationMillions) million"
        
        PlainListRow(name: "Population", value: populationString)
        PlainListRow(name: "Currency", value: currency)
        PlainListRow(name: "Animal", value: animal)
        
    }
    
    @ViewBuilder private func freedomView(_ freedoms: Freedoms) -> some View {
        Section {
            PlainListRow(name: "Civil Rights", value: AnyView(ColoredFreedomText(freedom: freedoms.civilRights)))
            PlainListRow(name: "Economy", value: AnyView(ColoredFreedomText(freedom: freedoms.economy)))
            PlainListRow(name: "Political Freedom", value: AnyView(ColoredFreedomText(freedom: freedoms.politicalFreedom)))
        }
    }
    
    @ViewBuilder private func regionView(_ regionName: String, influence: String) -> some View {
        Section {
            PlainListRow(
                name: "Region",
                value: regionName,
                action: {
                    if !isPresented {
                        showsRegionSheet.toggle()
                    } else {
                        navigation.push(.region(name: regionName))
                    }
                }
            )
            .sheet(isPresented: $showsRegionSheet) {
                Wrapped {
                    RegionView(viewModel: viewModelFactory.regionViewModel(regionName))
                }
                    .presentationDragIndicator(.visible)
            }
            PlainListRow(name: "Influence", value: influence)
        }
    }
}

struct NationView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @Environment(\.isPresented) private var isPresented
    @StateObject var viewModel: NationViewModel
    @StateObject var navigation = Navigation()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            List {
                self.listContents
            }
            .refreshable {
                await viewModel.refresh()
            }
            .toolbar {
                if !isPresented {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(
                            destination: viewModelFactory.searchView,
                            label: {
                                Image(systemName: "magnifyingglass")
                            }
                        )
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .environmentObject(navigation)
        }
    }
    
    private var nationNameView: some View {
        Section(header: Text("Nation Name")) {
            Text(self.viewModel.name)
        }
    }
    
    @ViewBuilder
    private var listContents: some View {
        if let nation = self.viewModel.nation {
            NationDetailsView(nation: nation)
        } else {
            nationNameView
        }
    }
}

final class Navigation: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ destination: NationDestionation) {
        path.append(destination)
    }
}

extension EnvironmentValues {
    private struct NavigationKey: EnvironmentKey {
        static let defaultValue = Navigation()
    }

    var navigation: Navigation {
        get { self[NavigationKey.self] }
        set { self[NavigationKey.self] = newValue }
    }
}

enum NationDestionation: Hashable {
    case region(name: String)
    case nation(name: String)
    case link(WorldAssemblyResolutionTextSheet.LinkType)
    case worldAssembly(WorldAssembly, Resolution)
}

#if DEBUG
#Preview {
    NationView(viewModel: .init(nation: .filler, name: "Le Nation "))
}
#endif
