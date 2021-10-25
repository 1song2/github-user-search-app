//
//  UsersRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

protocol UsersRepository {
    @discardableResult
    func fetchUsers(completion: @escaping (Result<Users, Error>) -> Void) -> Cancellable?
}
