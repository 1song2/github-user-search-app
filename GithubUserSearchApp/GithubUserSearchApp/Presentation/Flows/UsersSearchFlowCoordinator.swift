//
//  UsersSearchFlowCoordinator.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/31.
//

import UIKit

protocol UsersSearchFlowCoordinatorDependencies  {
    func makeUserViewController() -> UserViewController
}

final class UsersSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: UsersSearchFlowCoordinatorDependencies

    private weak var userVC: UserViewController?

    init(navigationController: UINavigationController,
         dependencies: UsersSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeUserViewController()
        navigationController?.pushViewController(vc, animated: false)
        userVC = vc
    }
}
