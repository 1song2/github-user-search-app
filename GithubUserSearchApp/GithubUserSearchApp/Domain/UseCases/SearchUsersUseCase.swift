//
//  SearchUsersUseCase.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation
import RxSwift

protocol SearchUsersUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue) -> Observable<Users>
}

final class DefaultSearchUsersUseCase: SearchUsersUseCase {
    private let usersRepository: UsersRepository
    
    init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }
    
    func execute(requestValue: SearchMoviesUseCaseRequestValue) -> Observable<Users> {
        return usersRepository.fetchUsers(query: requestValue.query)
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: String
}
