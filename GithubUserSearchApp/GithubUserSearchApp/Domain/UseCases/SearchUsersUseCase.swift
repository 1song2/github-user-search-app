//
//  SearchUsersUseCase.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation
import RxSwift

protocol SearchUsersUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue) -> Observable<(UsersPage, String?)>
}

final class DefaultSearchUsersUseCase: SearchUsersUseCase {
    private let usersRepository: UsersRepository
    
    init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }
    
    func execute(requestValue: SearchMoviesUseCaseRequestValue) -> Observable<(UsersPage, String?)> {
        return usersRepository.fetchUsers(query: requestValue.query, page: requestValue.page)
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: String
    let page: String
}
