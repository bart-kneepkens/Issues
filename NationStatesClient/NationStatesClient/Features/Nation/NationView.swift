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
    
    var nationNameView: some View {
        Section(header: Text("Nation Name")) {
            Text(self.viewModel.name)
        }
    }
    
    var accountSection: some View {
        Section(header: Text("Account")) {
            Button("Sign out \(self.viewModel.name)") {
                self.presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.async {
                    self.viewModel.signOut()
                }
            }.foregroundColor(.red)
        }
    }
    
    @ViewBuilder func flagView(_ path: String) -> some View {
        let url = URL(string: path)
        HStack {
            Spacer()
            CachedRemoteImage(url: url)
                .aspectRatio(contentMode: .fit)
                .frame(height: 64)
            Spacer()
        }
    }
    
    @ViewBuilder func nameView(fullName: String, name: String) -> some View {
        let prefix = fullName.replacingOccurrences(of: name, with: "")
        Group {
            Text(prefix)
            Text(name).font(.title).bold()
        }
    }
    
    @ViewBuilder func categoryView(_ category: String) -> some View {
        Text(category)
            .tracking(8)
            .opacity(0.8)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder func mottoView(_ motto: String) -> some View {
        Text("\"\(motto)\"").italic()
    }
    
    @ViewBuilder func freedomView(_ freedom: Freedom) -> some View {
        Section {
            HStack {
                Text("Civil Rights")
                Spacer()
                Text(freedom.civilRights)
            }
            
            HStack {
                Text("Economy")
                Spacer()
                Text(freedom.economy)
            }
            
            HStack {
                Text("Political Freedom")
                Spacer()
                Text(freedom.politicalFreedom)
            }
        }
    }
    
    var listContents: some View {
        Group {
            if let nation = self.viewModel.nation {
                VStack(alignment: .center, spacing: 10) {
                    flagView(nation.flagURL)
                    nameView(fullName: nation.fullName, name: nation.name)
                    categoryView(nation.category)
                    mottoView(nation.motto)
                }
                
                freedomView(nation.freedom)
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
        NavigationView {
            NationView(viewModel: .init(nation: .filler, name: "Le Nation "))
        }
    }
}
#endif
