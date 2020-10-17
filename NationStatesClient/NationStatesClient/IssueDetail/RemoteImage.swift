//
//  RemoteImage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/10/2020.
//

import SwiftUI

struct RemoteImage: View {
    private enum LoadState {
        case empty, success, failure
    }
    
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.empty
        
        init(url: URL?) {
            guard let parsedURL = url else {
                fatalError("Invalid URL: \(url?.absoluteString ?? "")")
            }
            
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }
    
    @StateObject private var loader: Loader
    var failure: Image
    
    var body: some View {
        let uiImage = UIImage(data: loader.data)
        
        if loader.state == .success && uiImage != nil {
            Image(uiImage: uiImage!).resizable()
        }
    }
    
    init(url: URL?, failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.failure = failure
    }
}
