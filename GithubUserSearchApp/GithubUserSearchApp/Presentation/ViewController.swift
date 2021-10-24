//
//  ViewController.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/22.
//

import UIKit

class ViewController: UIViewController {
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Private
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "GitHub Users" // viewModel.screenTitle
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        setupSearchController()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = [ // viewModel.buttonTitles
            NSLocalizedString("API", comment: ""),
            NSLocalizedString("Local", comment: "")
        ]
    }
}
