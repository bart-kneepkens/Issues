//
//  BasicImageCache.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/11/2020.
//

import Foundation
import UIKit

class BasicImageCache {
    static let shared = BasicImageCache()
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func get(for key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(image: UIImage, for key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
