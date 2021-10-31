//
//  APIEndpoints.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import Foundation

struct APIEndpoints {
    static func getUsers(with usersRequestDTO: UsersRequestDTO) -> Endpoint<UsersResponseDTO> {
        return Endpoint(path: "search/users",
                        method: .get,
                        queryParametersEncodable: usersRequestDTO)
    }
    
    static func getUserAvatar(path: String) -> Endpoint<Data> {
        return Endpoint(path: path,
                        isFullPath: true,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
