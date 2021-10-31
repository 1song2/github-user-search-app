//
//  StarredUsersEntity+Mapping.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/29.
//

import Foundation
import CoreData

extension StarredUserEntity {
    convenience init(item: UserViewModel, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = Int64(item.id)
        username = item.username
        avatarUrl = item.avatarUrl
        isStarred = true
    }
}

extension StarredUserEntity {
    func toDomain() -> User {
        return .init(id: Int(id),
                     username: username ?? "",
                     avatarUrl: avatarUrl ?? "",
                     isStarred: isStarred)
    }
}
