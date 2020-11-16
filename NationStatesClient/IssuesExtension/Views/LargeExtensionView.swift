//
//  LargeExtensionView.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct LargeExtensionView: View {
    var entry: IssuesEntry
    
    var body: some View {
        ZStack {
//            Image("f1_square").resizable()
            VStack {
                HStack {
                    VStack {
                        Text("\(entry.issues.count)").font(.title).fontWeight(.bold)
                        Text("Elest Adra")
                    }
                    Spacer()
                    Image(systemName: "newspaper").resizable().frame(width: 33, height: 33)
                }
                .padding(.horizontal)
                
                Divider()
                
                IssuesList(issues: entry.issues)
                Spacer()
            }.padding()
        }
    }
}

struct LargeExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        LargeExtensionView(entry: .init(date: Date(), issues: [.filler(1), .filler(2), .filler(3), .filler(4), .filler(5)]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
