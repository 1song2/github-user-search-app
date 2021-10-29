//
//  DataTransferError+LimitError.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/29.
//

import Foundation

extension DataTransferError: LimitError {
    var isRateLimitError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
              networkError.isForbiddenError else {
                  return false
              }
        return true
    }
}
