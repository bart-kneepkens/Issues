//
//  Authentication.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

enum AuthenticationMode {
    case pin
    case autologin
    case password
    
    var header: String {
        switch self {
        case .password: return "X-Password"
        case .autologin: return "X-Autologin"
        case .pin: return "X-Pin"
        }
    }
}

class Authentication: ObservableObject {
    static let shared = Authentication()
    private let storage: SecureStorage
    private var cancellables: [Cancellable] = []
    
    private init() {
        self.storage = UserDefaultsStorage()
        self.nationName = storage.retrieve(key: StorageKey.nationName)
        self.autoLogin = storage.retrieve(key: StorageKey.autoLogin)
        self.pin = storage.retrieve(key: StorageKey.pin)
    }
    
    var canPerformSilentLogin: Bool {
        return nationName != nil && (autoLogin != nil || pin != nil)
    }
    
    var nationName: String? {
        didSet {
            self.storage.store(nationName, key: StorageKey.nationName)
        }
    }
    
    var password: String? // Not to be stored
    
    var autoLogin: String? {
        didSet {
            self.storage.store(autoLogin, key: StorageKey.autoLogin)
        }
    }
    
    var pin: String? {
        didSet {
            self.storage.store(pin, key: StorageKey.pin)
        }
    }
    
    var isSigningIn: Bool = false
    @Published var signInSuccessful: Bool = false
    
    func attemptSignIn() {
        if canPerformSilentLogin, let nationName = self.nationName {
            self.isSigningIn = true
            self.cancellables.append(NationStatesAPI.ping(nationName: nationName).sink(receiveCompletion: { completion in
                self.isSigningIn = false
                self.objectWillChange.send()
            }, receiveValue: { ping in
                if ping {
                    self.signInSuccessful = true
                }
            }))
        }
    }
    
    func clear() {
        self.nationName = nil
        self.password = nil
        self.autoLogin = nil
        self.pin = nil
        self.signInSuccessful = false
        self.objectWillChange.send()
    }
}

extension Authentication {
    struct StorageKey {
        static let nationName = "nationName"
        static let autoLogin = "autoLogin"
        static let pin = "pin"
    }
}
