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
    @EnvironmentObject var user_settings:UserSettings
    @State var loaded = false
    var body: some View {
        if self.user_settings.access_token == nil {
            return AnyView(LoginView())
        }
        if !self.loaded {
            return AnyView(Text("Loading...").onAppear(perform: authorize_healthkit))
        }
        return AnyView(MainDashboard().onAppear(perform: authorize_healthkit))
    }
    
    func authorize_healthkit() {
        HealthKitAssistant.authorizeHealthKit().then{value in
            HealthKitAssistant.updateAllStats().then{v in
                self.loaded = v
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
