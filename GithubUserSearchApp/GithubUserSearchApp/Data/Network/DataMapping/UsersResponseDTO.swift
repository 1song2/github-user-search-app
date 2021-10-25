//
//  UsersResponseDTO.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

// MARK: - Data Transfer Object

struct UsersResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case totalNumberOfResults = "total_count"
        case users = "items"
    }
    let totalNumberOfResults: Int
    let users: [UserDTO]
}

extension UsersResponseDTO {
    struct UserDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case username = "login"
            case avatarUrl = "avatar_url"
        }
        let id: Int
        let username: String
        let avatarUrl: String
    }
}

// MARK: - Mappings to Domain

extension UsersResponseDTO {
    func toDomain() -> Users {
        return .init(totalNumberOfResults: totalNumberOfResults,
                     users: users.map { $0.toDomain() })
    }
}

extension UsersResponseDTO.UserDTO {
    func toDomain() -> User {
        return .init(id: id,
                     username: username,
                     avatarUrl: avatarUrl)
    }
}
