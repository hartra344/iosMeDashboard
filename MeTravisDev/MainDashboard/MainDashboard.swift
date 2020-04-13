//
//  MainDashboard.swift
//  MeTravisDev
//
//  Created by Travis Harris on 4/12/20.
//  Copyright © 2020 Travis Harris. All rights reserved.
//

import SwiftUI
import Introspect

struct MainDashboard: View {
    @State var meData: MainDashboardQuery.Data.Me? = nil
    var body: some View {
        VStack(alignment: .leading){
            List{
                Text("Hello, \(meData?.firstname ?? "NO NAME" ) \(meData?.lastname ?? "NO NAME")")
            }.introspectTableView { tableView in
                tableView.separatorStyle = .none
                tableView.separatorColor = .clear
            }.onAppear(perform: loaddata)
        }
    }
    
    func loaddata() {
        Network.shared.apollo.fetch(query: MainDashboardQuery()) {
            result in
            switch result {
            case .success(let graphQLResult):
                if let me = graphQLResult.data?.me {
                    self.meData = me;
                } else if let errors = graphQLResult.errors {
                    print(errors)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct MainDashboard_Previews: PreviewProvider {
    static var previews: some View {
        MainDashboard()
    }
}
