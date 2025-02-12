//
//  ToggleablePasswordField.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 21/12/2020.
//

import SwiftUI

struct ToggleablePasswordField: View {
    @Binding var text: String
    @State var shouldRevealPassword: Bool = false
    
    var body: some View {
        HStack {
            if shouldRevealPassword {
                TextField("Password", text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                SecureField("Password", text: $text)
            }
            Button(action: {
                self.shouldRevealPassword.toggle()
            }, label: {
                Image(systemName: shouldRevealPassword ? "eye.circle": "eye.slash.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundColor(shouldRevealPassword ? .accentColor : .secondary)
            })
        }
    }
}


#if DEBUG
struct ToggleablePasswordField_Previews: PreviewProvider {
    static var previews: some View {
        ToggleablePasswordField(text: .constant("hello"))
            .frame(width: 200, height: 200, alignment: .center)
    }
}
#endif
