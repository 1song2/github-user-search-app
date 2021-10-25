//
//  SearchUsersUseCase.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

protocol SearchUsersUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 completion: @escaping (Result<Users, Error>) -> Void)
}

final class DefaultSearchUsersUseCase: SearchUsersUseCase {
    private let usersRepository: UsersRepository

    init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }

    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 completion: @escaping (Result<Users, Error>) -> Void) {
        usersRepository.fetchUsers(query: requestValue.query) { result in
            completion(result)
        }
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: String
}
