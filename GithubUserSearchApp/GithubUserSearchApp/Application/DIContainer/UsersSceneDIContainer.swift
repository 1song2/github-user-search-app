//
//  UsersSceneDIContainer.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/31.
//

import UIKit

final class UsersSceneDIContainer {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    
    lazy var starredUsersCache: StarredUsersStorage = CoreDataStarredUsersStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    
    func makeSearchUsersUseCase() -> SearchUsersUseCase {
        return DefaultSearchUsersUseCase(usersRepository: makeUsersRepository())
    }
    
    // MARK: - Repositories
    
    func makeUsersRepository() -> UsersRepository {
        return DefaultUsersRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    func makeAvatarImagesRepository() -> AvatarImagesRepository {
        return DefaultAvatarImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    // MARK: - View Controller
    
    func makeUserViewController() -> UsersViewController {
        return UsersViewController.create(with: makeUsersViewModel(),
                                         avatarImagesRepository: makeAvatarImagesRepository())
    }
    
    func makeUsersViewModel() -> UsersViewModel {
        return DefaultUsersViewModel(searchUsersUseCase: makeSearchUsersUseCase(), cache: starredUsersCache)
    }
    
    // MARK: - Flow Coordinators
    
    func makeUsersSearchFlowCoordinator(navigationController: UINavigationController) -> UsersSearchFlowCoordinator {
        return UsersSearchFlowCoordinator(navigationController: navigationController,
                                          dependencies: self)
    }
}

extension UsersSceneDIContainer: UsersSearchFlowCoordinatorDependencies {}
