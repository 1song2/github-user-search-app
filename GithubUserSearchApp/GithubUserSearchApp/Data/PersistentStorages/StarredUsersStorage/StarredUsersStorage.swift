//
//  StarredUsersStorage.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/29.
//

import Foundation

protocol StarredUsersStorage {
    func getStarredUsers(completion: @escaping (Result<[User], CoreDataStorageError>) -> Void)
    func save(_ item: UserViewModel)
    func remove(_ item: UserViewModel)
}
