//
//  PlainListRow.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 06/01/2021.
//

import SwiftUI

struct PlainListRow: View {
    let name: String
    let value: String?
    let valueView: AnyView?
    var action: (() -> Void)?
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
        self.valueView = nil
    }
    
    init(name: String, value: AnyView) {
        self.name = name
        self.valueView = value
        self.value = nil
    }
    
    init(name: String, value: String, action: @escaping (() -> Void)) {
        self.name = name
        self.value = value
        self.valueView = nil
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text("\(name):")
            Spacer()
            if let valueView = self.valueView {
                valueView
            } else if let value = self.value {
                if let action {
                    Button {
                        action()
                    } label: {
                        Text(value).fontWeight(.medium)
                    }
                } else {
                    Text(value).fontWeight(.medium)
                }
            }
        }
    }
}

struct PlainListRow_Previews: PreviewProvider {
    static var previews: some View {
        PlainListRow(name: "name", value: "value")
    }
}
