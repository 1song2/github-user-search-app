//
//  UserViewModel.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/26.
//

import Foundation

struct UserViewModel {
    let username: String
    let avatarUrl: String
    var isStarred: Bool
    
    init(user: User) {
        self.username = user.username
        self.avatarUrl = user.avatarUrl
        self.isStarred = user.isStarred
    }
}
