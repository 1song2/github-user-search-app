//
//  UsersViewModel.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/28.
//

import Foundation
import RxSwift
import RxRelay

protocol UsersViewModelInput {
    func didSearch(query: String)
    func didLoadNextPage()
    func didCancelSearch()
    func didChangeSegment(_ index: Int)
    func didStar(_ item: UserViewModel)
}

protocol UsersViewModelOutput {
    var allItems: BehaviorSubject<[UserViewModel]> { get }
    var starredItems: [String: [UserViewModel]] { get }
    var filteredItems: BehaviorSubject<[Dictionary<String, [UserViewModel]>.Element]> { get }
    var searchText: String { get }
    var page: String { get }
    var error: PublishSubject<String> { get }
    var loading: BehaviorRelay<Bool> { get }
    var nextPageURL: String? { get }
    var selectedScopeButtonIndex: Int { get }
    var screenTitle: String { get }
    var buttonTitles: [String] { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol UsersViewModel: UsersViewModelInput, UsersViewModelOutput {}

final class DefaultUsersViewModel: UsersViewModel {
    private var disposeBag = DisposeBag()
    private let searchUsersUseCase: SearchUsersUseCase
    private let cache: StarredUsersStorage
    private var pages: [UsersPage] = []
    
    // MARK: - OUTPUT
    
    var allItems: BehaviorSubject<[UserViewModel]> = BehaviorSubject<[UserViewModel]>(value: [])
    var starredItems: [String: [UserViewModel]] = [:]
    var filteredItems: BehaviorSubject<[Dictionary<String, [UserViewModel]>.Element]> = BehaviorSubject<[Dictionary<String, [UserViewModel]>.Element]>(value: [])
    var searchText: String = ""
    var page: String = ""
    var error: PublishSubject<String> = PublishSubject<String>()
    var loading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var nextPageURL: String?
    var selectedScopeButtonIndex: Int = 0
    
    let screenTitle = NSLocalizedString("GitHub Users", comment: "")
    let buttonTitles = [NSLocalizedString("All", comment: ""),
                        NSLocalizedString("Starred", comment: "")]
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Users", comment: "")
    
    // MARK: - Init
    
    init(searchUsersUseCase: SearchUsersUseCase,
         cache: StarredUsersStorage) {
        self.searchUsersUseCase = searchUsersUseCase
        self.cache = cache
        cache.getStarredUsers { [weak self] result in
            switch result {
            case .success(let users):
                guard let self = self else { return }
                self.starredItems = Dictionary(grouping: users.map(UserViewModel.init),
                                               by: { $0.username.first?.uppercased() ?? "" })
                self.filteredItems.onNext(self.starredItems.sorted(by: { $0.key < $1.key }))
            case .failure(let error):
                self?.handle(error: error)
            }
        }
    }
    
    // MARK: - Private
    
    private func appendPage(_ usersPage: UsersPage) {
        pages = pages + [usersPage]
        
        allItems.onNext(pages.users.map { user in
            let userViewModel = UserViewModel(user: user)
            if starredItems.values
                .flatMap({ $0 })
                .contains(where: { viewModel in viewModel.id == user.id }) {
                userViewModel.didStar(true)
            }
            return userViewModel
        })
    }
    
    private func resetPages() {
        pages.removeAll()
        allItems.onNext([])
    }
    
    private func load(query: String) {
        guard !loading.value else { return }
        self.searchText = query
        self.page = "1"
        self.loading.accept(true)
        searchUsersUseCase.execute(
            requestValue: .init(query: query, page: page))
            .subscribe(
                onNext: { [weak self] in
                    self?.appendPage($0.0)
                    self?.nextPageURL = $0.1
                    self?.loading.accept(false)
                }
                ,onError: { [weak self] in
                    self?.handle(error: $0)
                    self?.loading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func loadNextPage() {
        guard !loading.value else { return }
        guard selectedScopeButtonIndex == 0 else { return }
        guard let nextPageURL = nextPageURL else { return }
        guard let urlComponents = URLComponents(string: nextPageURL) else {return }
        searchText = urlComponents.queryItems?.first { $0.name == "q" }?.value ?? ""
        page = urlComponents.queryItems?.first { $0.name == "page" }?.value ?? ""
        self.loading.accept(true)
        searchUsersUseCase.execute(
            requestValue: .init(query: searchText, page: page))
            .subscribe(
                onNext: { [weak self] in
                    self?.appendPage($0.0)
                    self?.nextPageURL = $0.1
                    self?.loading.accept(false)
                }
                ,onError: { [weak self] in
                    self?.handle(error: $0)
                    self?.loading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func handle(error: Error) {
        let errorString = error.isInternetConnectionError
        ? NSLocalizedString("인터넷이 연결되지 않았습니다", comment: "")
        : error.isRateLimitError
        ? NSLocalizedString("기본 요청 횟수를 초과했습니다. 잠시 후 다시 시도해주세요.", comment: "")
        : NSLocalizedString("유저를 불러오는 데 실패했습니다.", comment: "")
        
        self.error.onNext(errorString)
    }
    
    private func update(query: String) {
        resetPages()
        load(query: query)
    }
}

// MARK: - INPUT. View event methods

extension DefaultUsersViewModel {
    func didSearch(query: String) {
        if selectedScopeButtonIndex == 0 {
            guard !query.isEmpty else { return }
            update(query: query)
        } else {
            if query.isEmpty {
                filteredItems.onNext(starredItems.sorted(by: { $0.key < $1.key }))
            } else {
                let filteredArray = starredItems.values.flatMap { $0 }
                    .filter { $0.username.uppercased().contains(query.uppercased()) }
                let filteredDict = Dictionary(grouping: filteredArray, by: { $0.username.first?.uppercased() ?? "" })
                filteredItems.onNext(filteredDict.sorted(by: { $0.key < $1.key }))
            }
        }
    }
    
    func didLoadNextPage() {
        loadNextPage()
    }
    
    func didCancelSearch() {
        disposeBag = DisposeBag()
    }
    
    func didChangeSegment(_ index: Int) {
        selectedScopeButtonIndex = index
        if selectedScopeButtonIndex == 0 {
            filteredItems.onNext(self.starredItems.sorted(by: { $0.key < $1.key }))
        }
    }
    
    func didStar(_ item: UserViewModel) {
        guard let initialLetter = item.username.first?.uppercased() else { return }
        if (starredItems.filter { $0.value.contains(item) }.count > 0) {
            cache.remove(item)
            guard let index = starredItems[initialLetter]?.firstIndex(of: item) else { return }
            starredItems[initialLetter]?.remove(at: index)
        } else {
            if starredItems[initialLetter] != nil {
                starredItems[initialLetter]!.append(item)
            } else {
                starredItems[initialLetter] = [item]
            }
            cache.save(item)
        }
    }
}

// MARK: - Private

private extension Array where Element == UsersPage {
    var users: [User] { flatMap { $0.users } }
}
