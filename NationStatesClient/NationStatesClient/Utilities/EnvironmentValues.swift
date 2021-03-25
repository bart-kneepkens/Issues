//
//  EnvironmentValues.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/03/2021.
//

import SwiftUI

// This should be the only living instance
// We don't have to pass it explicitly anywhere, because we can just provide it as a default value.
fileprivate let viewModelFactory = ViewModelFactory()

fileprivate struct ViewModelFactoryEnvironmentKey: EnvironmentKey {
    static var defaultValue: ViewModelFactory = viewModelFactory
}

extension EnvironmentValues {
    var viewModelFactory: ViewModelFactory {
        get { self[ViewModelFactoryEnvironmentKey.self] }
        set { self[ViewModelFactoryEnvironmentKey.self] = newValue }
    }
}
