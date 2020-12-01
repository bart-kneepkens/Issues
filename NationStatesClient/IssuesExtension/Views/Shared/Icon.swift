//
//  Icon.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 01/12/2020.
//

import SwiftUI

struct Icon: View {
    var body: some View {
        Image(systemName: "newspaper").resizable().frame(width: 30, height: 30)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon()
    }
}
