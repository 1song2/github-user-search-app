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
    func fetchUsers(query: String, page: Int) -> Observable<UsersPage> {
        return Observable.create { [weak self] emitter in
            let requestDTO = UsersRequestDTO(q: query, page: page)
            let endpoint = APIEndpoints.getUsers(with: requestDTO)
            self?.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    emitter.onNext(responseDTO.toDomain())
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
