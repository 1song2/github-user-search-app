//
//  AvatarImagesRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

protocol AvatarImagesRepository {
    func fetchImage(with imagePath: String,
                    completion: @escaping (Result<Data, Error>) -> Void)
}
