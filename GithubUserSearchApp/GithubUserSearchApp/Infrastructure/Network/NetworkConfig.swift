//
//  NetworkConfig.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/24.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
}
