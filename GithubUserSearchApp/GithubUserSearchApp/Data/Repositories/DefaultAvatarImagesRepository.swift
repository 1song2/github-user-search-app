//
//  DefaultAvatarImagesRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation
import RxSwift

final class DefaultAvatarImagesRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultAvatarImagesRepository: AvatarImagesRepository {
    func fetchImage(with imagePath: String) -> Observable<Data> {
        return Observable.create { [weak self] emitter in
            let endpoint = APIEndpoints.getUserAvatar(path: imagePath)
            self?.dataTransferService.request(with: endpoint) { result in
                let result = result.mapError { $0 as Error }
                switch result {
                case .success(let (data, _)):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
