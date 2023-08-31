//
//  Combine+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/09/2023.
//

import Combine

extension Publisher where Self.Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, onWeak object: Root) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
