//
//  NetworkConfigurableMock.swift
//  GithubUserSearchAppTests
//
//  Created by Song on 2021/10/24.
//

import XCTest

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
}
