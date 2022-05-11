import Apollo

final class ViewModel {
    
    private let client: GraphQLClient
    
    var didUpdateViewState: ((ViewModelState) -> Void)?
    
    init(client: GraphQLClient = ApolloClient.shared) {
        self.client = client
    }
    
    func search(phrase: String, endCursor: String = "") {
        didUpdateViewState?(.isLoading(true))
        
        var filter: SearchRepositoriesQuery.Filter? = nil
        if !endCursor.isEmpty {
            filter = .after(Cursor(rawValue: endCursor))
        }
        
        self.client.searchRepositories(mentioning: phrase, filter: filter) { [weak self] response in
            guard let self = self else { return }
            
            self.didUpdateViewState?(.isLoading(false))
            
            switch response {
            case let .failure(error):
                self.didUpdateViewState?(.hasError(error))
                
            case let .success(results):
                let serachResultViewEntity = SerachResultViewlEntity(repos: results.repos, pageInfo: results.pageInfo)
                self.didUpdateViewState?(.hasData(serachResultViewEntity))
            }
        }
    }
    
}
