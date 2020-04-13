//
//  LoginViewModel.swift
//  MeTravisDev
//
//  Created by Travis Harris on 4/12/20.
//  Copyright © 2020 Travis Harris. All rights reserved.
//

import Foundation
import KeychainSwift


class UserSettings: ObservableObject {
    @Published var access_token: String?
    
    init() {
        access_token = KeychainSwift().get(Constants.loginKeychainKey)
    }
    
    func setAccessToken(token: String?) {
        if let t = token {
            KeychainSwift().set(t, forKey:Constants.loginKeychainKey )
        } else {
            KeychainSwift().delete(Constants.loginKeychainKey )
        }
        self.access_token = token;
    }
}
