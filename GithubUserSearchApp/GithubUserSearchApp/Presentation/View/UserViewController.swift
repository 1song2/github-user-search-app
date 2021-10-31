//
//  ViewController.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/22.
//

import UIKit

class UserViewController: UITableViewController {
    private var searchController = UISearchController(searchResultsController: nil)
    
    static func create(with viewModel: UsersViewModel,
                       avatarImagesRepository: AvatarImagesRepository?) -> UserViewController {
        let view = UserViewController()
        view.viewModel = viewModel
        view.avatarImagesRepository = avatarImagesRepository
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.screenTitle
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        tableView.register(UserCell.nib(), forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.rowHeight = UserCell.height
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = viewModel.buttonTitles
        definesPresentationContext = true
    }
}

// MARK: - UISearchBarDelegate

extension UserViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}
