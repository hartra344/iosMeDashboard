//
//  ContentView.swift
//  MeTravisDev
//
//  Created by Travis Harris on 4/12/20.
//  Copyright © 2020 Travis Harris. All rights reserved.
//

import SwiftUI
import KeychainSwift
struct ContentView: View {
    let keychain = KeychainSwift()
    
    @State var token: String? = nil
    
    var body: some View {
        
        if self.token == nil {
            return AnyView(LoginView().onAppear(perform: checkLogin))
        }
        return AnyView(MainDashboard())
    }
    func checkLogin() {
        self.token = keychain.get(LoginView.loginKeychainKey)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
