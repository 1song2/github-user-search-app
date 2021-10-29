//
//  UsersRequestDTO.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

struct UsersRequestDTO: Encodable {
    let q: String
    let page: String
}
