//
//  NationIssuesView.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 01/12/2020.
//

import SwiftUI

struct NationIssuesView: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            Icon()
            Text("\(entry.fetchIssuesResult.issues.count)")
                .font(.title)
                .fontWeight(.bold)
        }
    }
}

#if DEBUG
struct NationIssuesView_Previews: PreviewProvider {
    static var previews: some View {
        NationIssuesView(entry: .filler(nationName: "Elest Adra"))
    }
}
#endif
