//
//  DefaultAvatarImagesRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

final class DefaultAvatarImagesRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultAvatarImagesRepository: AvatarImagesRepository {
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let endpoint = APIEndpoints.getUserAvatar(path: imagePath)
        dataTransferService.request(with: endpoint) { result in
            let result = result.mapError { $0 as Error }
            completion(result)
        }
    }
}
