//
//  ViewController.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UserViewController: UITableViewController {
    private var viewModel: UsersViewModel!
    private var avatarImagesRepository: AvatarImagesRepository?
    private var disposeBag = DisposeBag()
    private var searchController = UISearchController(searchResultsController: nil)
    typealias AlphabeticalSectionModel = SectionModel<String, UserViewModel>
    typealias AlphabeticalDataSource = RxTableViewSectionedReloadDataSource<AlphabeticalSectionModel>
    private var alphabeticalDataSource: AlphabeticalDataSource {
        let configureCell: (TableViewSectionedDataSource<AlphabeticalSectionModel>,
                            UITableView, IndexPath, UserViewModel) -> UITableViewCell = { [weak self] (datasource, tableView, indexPath, item) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier,
                                                           for: indexPath) as? UserCell else { return UITableViewCell() }
            self?.configureCell(cell, with: item)
            return cell
        }
        
        let datasource = AlphabeticalDataSource(configureCell: configureCell)
        datasource.titleForHeaderInSection = { datasource, index in
            return datasource.sectionModels[index].model
        }
        return datasource
    }
    
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
        setupBindings()
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
    
    private func setupBindings() {
        searchController.searchBar.rx.selectedScopeButtonIndex.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.didChangeSegment($0)
                self.tableView.dataSource = nil
                if $0 == 0 {
                    self.viewModel.allItems
                        .bind(to: self.tableView.rx.items(cellIdentifier: UserCell.reuseIdentifier,
                                                          cellType: UserCell.self)) { [weak self] _, item, cell in
                            self?.configureCell(cell, with: item)
                        }.disposed(by: self.disposeBag)
                } else {
                    let sections = Observable.just(
                        self.viewModel.starredItems.value
                            .sorted { $0.key < $1.key }
                            .map { SectionModel<String, UserViewModel>(model: $0, items: $1) }
                    )
                    sections.bind(to: self.tableView.rx.items(dataSource: self.alphabeticalDataSource))
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let alert = UIAlertController(title: "Error", message: $0, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = viewModel.buttonTitles
        definesPresentationContext = true
    }
    
    private func configureCell(_ cell: UserCell, with userViewModel: UserViewModel) {
        cell.usernameLabel.text = userViewModel.username
        cell.updateAvatarImage(with: userViewModel, avatarImagesRepository: avatarImagesRepository)
        cell.onToggled = {
            userViewModel.didStar($0)
            self.viewModel.didStar(userViewModel)
        }
        userViewModel.isStarred
            .subscribe(onNext: {
                let imageName = $0 ? "star-fill" : "star"
                cell.starButton.setImage(UIImage(named: imageName), for: [])
            })
            .disposed(by: cell.disposeBag)
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

// MARK: - UITableViewDelegate

extension UserViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + 200.0 >= scrollView.contentSize.height) {
            self.viewModel.didLoadNextPage()
        }
    }
}
