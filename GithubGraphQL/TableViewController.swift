import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = ViewModel()
    
    private var repositories: [RepositoryDetails] = []
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.search(phrase: "graphql")
        setup()
    }
    
}

// MARK: - Private Implementation
private extension TableViewController {
    
    func setup() {
        bindViewModelClousures()
        setupNavigationBar()
        setupSerachController()
        setupTableView()
        setupConstraints()
    }
    
    func bindViewModelClousures() {
        viewModel.didUpdateViewState = { [weak self] viewModelState in
            guard let self = self else { return }
            switch viewModelState {
            case .hasData(let searchResultViewEntity):
                self.repositories = searchResultViewEntity.repos
                //DispatchQueue.main.sync {
                    self.tableView.reloadData()
                //}
            default:
                print("Foo")
            }
            
            
        }
    }
    
    func setupNavigationBar() {
        definesPresentationContext = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemGray6
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.setStatusBar(backgroundColor: .systemGray6)
        navigationItem.title = "GitHub Search"
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.backgroundColor = .systemGray6
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.refreshControl = UIRefreshControl()
    }
    
    func setupSerachController() {
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.automaticallyShowsScopeBar = false
        
        searchController.searchBar.backgroundColor = .systemGray6
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = .systemGray6
        searchController.searchBar.text = "graphql"
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchController.searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - SearchBar Delegate
extension TableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}

// MARK: - TableView Delegate
extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? TableViewCell else { return UITableViewCell() }

        cell.name = "\(repositories[indexPath.row].owner.login)/\(repositories[indexPath.row].name)"
        cell.repositoryDescription = repositories[indexPath.row].description ?? ""
        cell.stars = String(repositories[indexPath.row].stargazers.totalCount)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
