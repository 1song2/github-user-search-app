//
//  UsersRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation
import RxSwift

protocol UsersRepository {
    func fetchUsers(query: String, page: String) -> Observable<(UsersPage, String?)>
}
