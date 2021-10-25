//
//  User.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let avatarUrl: String
    let isStarred: Bool
}

struct Users {
    let totalNumberOfResults: Int
    let users: [User]
}
