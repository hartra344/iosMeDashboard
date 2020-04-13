//
//  MainDashboard.swift
//  MeTravisDev
//
//  Created by Travis Harris on 4/12/20.
//  Copyright © 2020 Travis Harris. All rights reserved.
//

import SwiftUI
import Introspect
import SwiftDate
struct MainDashboard: View {
    @State var meData: MainDashboardQuery.Data.Me? = nil
    @State var statsData: [MainDashboardQuery.Data.Stat.Node] = []
    @EnvironmentObject var user_settings:UserSettings
    var body: some View {
        let weightString = statsData.count > 0 ? "\(statsData[0].weight ?? 0.0)" :""
        return NavigationView {
            VStack(alignment: .leading){
                List{
                    Text("Hello, \(meData?.firstname ?? "NO NAME" ) \(meData?.lastname ?? "NO NAME") and you weigh \(weightString) lbs")
                    VStack(alignment: .center){
                        Button(action:{
                            self.user_settings.setAccessToken(token: nil)
                        }){
                            Text("Logout")
                        }
                    }
                }.introspectTableView { tableView in
                    tableView.separatorStyle = .none
                    tableView.separatorColor = .clear
                }.onAppear(perform: loaddata)
            }.navigationBarTitle("Dashboard")
        }
        
    }
    
    func loaddata() {
        let reg = Region(calendar: Calendars.gregorian, zone: Zones.americaLosAngeles, locale: Locales.englishUnitedStates)
        SwiftDate.defaultRegion = reg;
        let date = Date().toISO()
        debugPrint(date)
        Network.shared.apollo.fetch(query: MainDashboardQuery(date:date)) {
            result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    self.meData = data.me
                    debugPrint(data.stats.nodes)
                    self.statsData = data.stats.nodes ?? []
                } else if let errors = graphQLResult.errors {
                    print(errors)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
