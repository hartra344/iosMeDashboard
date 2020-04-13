//
//  Network.swift
//  MeTravisDev
//
//  Created by Travis Harris on 4/12/20.
//  Copyright © 2020 Travis Harris. All rights reserved.
//

import Foundation
import Apollo
import KeychainSwift

class Network {
    static let shared = Network()
    
    private(set) lazy var apollo: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(url: URL(string: "https://api.travis.dev/graphql")!)
        httpNetworkTransport.delegate = self
        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
}

extension Network: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        let keychain = KeychainSwift()
        if let token = keychain.get(Constants.loginKeychainKey) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } // else do nothing
    }
    
    
}
