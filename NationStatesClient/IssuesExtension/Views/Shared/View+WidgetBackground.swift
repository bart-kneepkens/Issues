//
//  View+WidgetBackground.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 18/11/2023.
//

import SwiftUI

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
