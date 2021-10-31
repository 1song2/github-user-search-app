//
//  LimitError.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/29.
//

import Foundation

protocol LimitError: Error {
    var isRateLimitError: Bool { get }
}

extension Error {
    var isRateLimitError: Bool {
        guard let error = self as? LimitError, error.isRateLimitError else {
            return false
        }
        return true
    }
}
