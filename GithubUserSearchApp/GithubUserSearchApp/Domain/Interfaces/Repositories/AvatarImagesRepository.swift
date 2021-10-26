//
//  AvatarImagesRepository.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation
import RxSwift

protocol AvatarImagesRepository {
    func fetchImage(with imagePath: String) -> Observable<Data>
}
