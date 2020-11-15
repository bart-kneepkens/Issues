//
//  SmallExtensionView.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct SmallExtensionView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            ZStack {
                Image("f1_square").resizable()
                IssuesAmountView(amount: entry.issues.count)
            }
        }
    }
}

struct SmallExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        SmallExtensionView(entry: .init(date: Date(), issues: [.filler(1)])).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
