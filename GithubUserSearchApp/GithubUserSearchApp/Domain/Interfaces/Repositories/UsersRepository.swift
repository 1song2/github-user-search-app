//
//  UsersRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

protocol UsersRepository {
    func fetchUsers(query: String,
                    completion: @escaping (Result<Users, Error>) -> Void)
}
