//
//  UserViewModel.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/26.
//

import Foundation
import RxSwift
import RxRelay

class UserViewModel: Hashable {
    let id: Int
    let username: String
    let avatarUrl: String
    var isStarred: BehaviorRelay<Bool>
    
    init(user: User) {
        self.id = user.id
        self.username = user.username
        self.avatarUrl = user.avatarUrl
        self.isStarred = BehaviorRelay<Bool>(value: user.isStarred)
    }
    
    func didStar(_ bool: Bool) {
        isStarred.accept(bool)
    }
    
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
