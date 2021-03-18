//
//  ErrorView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 06/12/2020.
//

import SwiftUI

struct ErrorView: View {
    let error: APIError
    var onPress: (() -> Void)?
    
    private var text: String {
        switch error {
        case .notConnected: return "There appears to be no internet connection. Are you connected?"
        case .unauthorized: return "There appears to be an authentication problem. Tap here to sign in."
        case .rateExceeded: fallthrough
        case .timedOut: return "There appear to be some connection issues. Retrying.."
        case .nationNotFound: return "Nation not found"
            
            #if DEBUG
            case .conflict: return "conflict"
            case .notFound: return "notFound"
            case .unknown(let errorCode): return "unknown error with response code: \(errorCode)"
            #endif
        default: return "Unknown error"
        }
    }
    
    var body: some View {
        Button(action: {
            self.onPress?()
        }, label: {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                Text(text)
            }
        }).buttonStyle(PlainButtonStyle())
    }
}

extension ErrorView {
    public mutating func onPress(onPress: @escaping () -> Void) {
        self.onPress = onPress
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: .unauthorized)
    }
}
