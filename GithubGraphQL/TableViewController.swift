import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = ViewModel()
    private let activityIndicator = UIActivityIndicatorView()

    private var searchTerms = "graphql"
    private var endCursor = ""
    
    private var repositories: [RepositoryDetails] = []
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.search(phrase: searchTerms)
    }
    
}

// MARK: - Private Implementation
private extension TableViewController {
    
    func setup() {
        bindViewModelClousures()
        setupActivityIndicator()
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupConstraints()
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemBlue
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
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
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func setupSearchController() {
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.automaticallyShowsScopeBar = false
        
        searchController.searchBar.backgroundColor = .systemGray6
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = .systemGray6
        searchController.searchBar.delegate = self
        searchController.searchBar.text = searchTerms
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchController.searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func bindViewModelClousures() {
        viewModel.didUpdateViewState = { [weak self] viewModelState in
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            switch viewModelState {
            case .hasData(let searchResultViewEntity):
                self.repositories.append(contentsOf: searchResultViewEntity.repos)
                self.endCursor = searchResultViewEntity.pageInfo.endCursor ?? ""
                self.tableView.reloadData()
            case .hasError:
                self.handleError()
            case .isLoading(let isLoading):
                if isLoading {
                    self.activityIndicator.startAnimating()
                    return
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func handleError() {
        let alert = UIAlertController(title: "Error", message: "Someting went wrong. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.search(phrase: self.searchTerms)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

}

// MARK: - SearchBar Delegate
extension TableViewController: UISearchBarDelegate {
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchController.searchBar.text ?? ""
        repositories = []
        viewModel.search(phrase: searchText)
        searchController.dismiss(animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTerms = searchBar.text ?? ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerms = searchBar.text ?? ""
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchTerms
    }
    
}

// MARK: - UITableView and UIScrollView Delegate
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
        cell.stars = repositories[indexPath.row].stargazers.totalCount.roundedWithAbbreviations
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: repositories[indexPath.row].url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY >= (scrollView.contentSize.height - scrollView.bounds.height) - 20 {
            viewModel.search(phrase: searchTerms, endCursor: endCursor)
        }
    }

}


//MARK: - Private Objective-C Actions Implementations
@objc private extension TableViewController {
    
    func refresh() {
        repositories = []
        viewModel.search(phrase: searchTerms)
    }
    
}

