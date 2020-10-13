//
//  ContentViewViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 14/10/2020.
//

import Foundation

class ContentViewViewModel: ObservableObject {
    @Published var canPerformSilentLogin = Authentication.shared.canPerformSilentLogin
}
