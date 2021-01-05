//
//  NationView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/10/2020.
//

import SwiftUI

struct NationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: NationViewModel
    
    private var nationNameView: some View {
        Section(header: Text("Nation Name")) {
            Text(self.viewModel.name)
        }
    }
    
    private var accountSection: some View {
        Section(header: Text("Account")) {
            Button("Sign out \(self.viewModel.name)") {
                self.presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.async {
                    self.viewModel.signOut()
                }
            }.foregroundColor(.red)
        }
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
    
    @ViewBuilder private func nameView(fullName: String, name: String) -> some View {
        let prefix = fullName.replacingOccurrences(of: name, with: "")
        Group {
            Text(prefix)
            Text(name).font(.title).bold()
        }
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
            PlainListRow(name: "Region", value: regionName)
            PlainListRow(name: "Influence", value: influence)
        }
    }
    
    private var listContents: some View {
        Group {
            if let nation = self.viewModel.nation {
                VStack(alignment: .center, spacing: 10) {
                    flagView(nation.flagURL)
                    nameView(fullName: nation.fullName, name: nation.name)
                    categoryView(nation.category)
                    mottoView(nation.motto)
                }.padding(.bottom)
                
                generalStatisticsView(nation.populationMillions, currency: nation.currency, animal:nation.animal)
                
                freedomView(nation.freedoms)
                
                regionView(nation.regionName, influence: nation.regionInfluence)
            } else {
                nationNameView
            }
            
            accountSection
        }
    }
    
    var body: some View {
        List {
            self.listContents
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("", displayMode: .inline)
    }
}

#if DEBUG
struct NationView_Previews: PreviewProvider {
    static var previews: some View {
        NationView(viewModel: .init(nation: .filler, name: "Le Nation "))
    }
}
#endif
