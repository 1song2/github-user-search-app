//
//  DefaultUsersRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation
import RxSwift

final class DefaultUsersRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultUsersRepository: UsersRepository {
    func fetchUsers(query: String, page: String) -> Observable<(UsersPage, String?)> {
        return Observable.create { [weak self] emitter in
            let requestDTO = UsersRequestDTO(q: query, page: page)
            let endpoint = APIEndpoints.getUsers(with: requestDTO)
            self?.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let pair):
                    emitter.onNext((pair.0.toDomain(), pair.1))
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
