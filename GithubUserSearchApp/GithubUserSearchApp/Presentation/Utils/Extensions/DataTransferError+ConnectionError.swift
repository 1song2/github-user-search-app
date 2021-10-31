//
//  DataTransferError+ConnectionError.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/29.
//

import Foundation

extension DataTransferError: ConnectionError {
    var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
              case .notConnected = networkError else {
                  return false
              }
        return true
    }
}
