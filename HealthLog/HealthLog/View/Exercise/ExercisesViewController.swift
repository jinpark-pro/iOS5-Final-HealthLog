//
//  ExerciseViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import Combine
import UIKit

class ExercisesViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Declare
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ExerciseViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let addButton = UIButton(type: .custom)
    private let dividerView = UIView()
    private let tableView = UITableView()
    
    //MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchController()
        setupSearchBarView()
        setupDivider()
        setupTableView()
        setupBinding()
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        title = "운동 목록"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // MARK: addButton
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "+"
        buttonConfig.baseBackgroundColor = .colorAccent
        buttonConfig.baseForegroundColor = .white
        buttonConfig.cornerStyle = .fixed
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 8, bottom: 2, trailing: 8)
        addButton.configuration = buttonConfig
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = BodyPartOption.allName
        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.showsScopeBar = true
//        tableView.tableHeaderView = searchController.searchBar
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.scopeButtonTitles = BodyPartOption.allName
        searchBar.showsScopeBar = true
        let placeHolder = NSAttributedString(
            string: "운동명 입력",
            attributes: [NSAttributedString.Key.foregroundColor:
                            UIColor.lightGray]
        )
        searchBar.searchTextField.attributedPlaceholder = placeHolder
        searchBar.searchTextField.textColor = .white
    }
    
    func setupSearchBarView() {
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.delegate = self
//        searchBar.sizeToFit()
//        searchBar.barTintColor = .black
//        searchBar.searchTextField.backgroundColor = .colorSecondary
//        searchBar.searchTextField.textColor = .white
//        let placeHolder = NSAttributedString(
//            string: "검색어 입력",
//            attributes: [NSAttributedString.Key.foregroundColor:
//                            UIColor.lightGray])
//        searchBar.searchTextField.attributedPlaceholder = placeHolder
//        view.addSubview(searchBar)
//        
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])
    }
    
    func setupDivider() {
        dividerView.backgroundColor = UIColor.lightGray // 구분선 색상 설정
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1)
        ])
    }
    
    func setupTableView() {
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseListCell.self, forCellReuseIdentifier: "ExerciseCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBinding() {
        // 바인딩 - 검색시 테이블 리로드 실행
        viewModel.$filteredExercises
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                print("tableView - reload")
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let selectedOption: BodyPartOption
        if selectedScope == 0 {
            selectedOption = .all
        } else {
            let bodyPart = BodyPart.allCases[selectedScope - 1]
            selectedOption = .bodyPart(bodyPart)
        }
        print("searchBar selectedScope - \(selectedOption.name)")
        viewModel.selectedOption = selectedOption
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.updateSearchText(to: searchText)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView Count - \(viewModel.filteredExercises.count)")
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseListCell
        cell.configure(with: viewModel.filteredExercises[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: Methods
    
    @objc func addButtonTapped() {
        print("addButtonTapped!")
        let vc = TempViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        viewModel.filterExercises(by: "")
//        searchBar.resignFirstResponder()
//    }
    
}
