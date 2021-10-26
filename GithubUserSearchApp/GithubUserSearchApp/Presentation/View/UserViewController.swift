//
//  ViewController.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/22.
//

import UIKit

class UserViewController: UITableViewController {
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
        tableView.register(UserCell.nib(), forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.rowHeight = UserCell.height
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

//MARK: - UITableViewDataSource
extension UserViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        return cell
    }
}
