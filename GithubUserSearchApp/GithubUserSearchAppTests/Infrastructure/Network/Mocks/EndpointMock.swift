//
//  EndpointMock.swift
//  GithubUserSearchAppTests
//
//  Created by Song on 2021/10/24.
//

import XCTest

struct EndpointMock: Requestable {
    var path: String
    var isFullPath: Bool = false
    var method: HTTPMethodType
    var headerParameters: [String: String] = [:]
    var queryParametersEncodable: Encodable?
    
    init(path: String, method: HTTPMethodType) {
        self.path = path
        self.method = method
    }
}

enum NetworkErrorMock: Error {
    case someError
}
