//
//  DefaultUsersRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

final class DefaultUsersRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultUsersRepository: UsersRepository {
    func fetchUsers(query: String,
                    completion: @escaping (Result<Users, Error>) -> Void) {
        let requestDTO = UsersRequestDTO(q: query)
        let endpoint = APIEndpoints.getUsers(with: requestDTO)
        dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
