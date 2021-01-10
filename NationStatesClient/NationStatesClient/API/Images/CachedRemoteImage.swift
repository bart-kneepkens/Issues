//
//  CachedRemoteImage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/10/2020.
//

import SwiftUI

struct CachedRemoteImage: View {
    private enum LoadState {
        case empty, loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var image: UIImage?
        var state = LoadState.empty
        private let cache = BasicImageCache.shared
        
        init(url: URL?) {
            guard let parsedURL = url else {
                print("Invalid URL: \(url?.absoluteString ?? "")")
                return
            }
            
            guard state == .empty else { return }
            
            self.state = .loading
            
            if let cachedImage = self.cache.get(for: parsedURL.absoluteString) {
                self.image = cachedImage
                self.state = .success
                return
            }
            
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                print("Fetched Image from \(parsedURL)")
                
                if let data = data, data.count > 0 {
                    self.image = UIImage(data: data)
                    self.state = .success
                    
                    if let image = UIImage(data: data) {
                        self.cache.set(image: image, for: parsedURL.absoluteString)
                    }
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }
    
    @ObservedObject private var loader: Loader
    
    var body: some View {
        if loader.state == .loading {
            ProgressView()
        } else if loader.state == .success, let image = loader.image {
            Image(uiImage: image).resizable()
        }
    }
    
    init(url: URL?) {
        self.loader = Loader(url: url)
    }
}
