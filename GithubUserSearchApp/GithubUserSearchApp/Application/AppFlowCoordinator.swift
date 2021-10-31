//
//  AppFlowCoordinator.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/31.
//

import UIKit

final class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let usersSceneDIContainer = appDIContainer.makeUsersSceneDIContainer()
        let flow = usersSceneDIContainer.makeUsersSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
