import Apollo

struct SerachResultViewlEntity {
    let repos: [RepositoryDetails]
    let pageInfo: SearchRepositoriesQuery.Data.Search.PageInfo
}

enum ViewModelState {
    case hasData(SerachResultViewlEntity)
    case hasError(Error)
    case isLoading(_ isLoading: Bool)
}

enum APIError: Error {
    case generic
}

final class ViewModel {
    private let client: GraphQLClient
    
    var didUpdateViewState: ((ViewModelState) -> Void)?
    
    init(client: GraphQLClient = ApolloClient.shared) {
        self.client = client
    }
    
    func search(phrase: String) {
        didUpdateViewState?(.isLoading(true))
        
        self.client.searchRepositories(mentioning: phrase) { [weak self] response in
            guard let self = self else { return }
            
            self.didUpdateViewState?(.isLoading(false))
            
            switch response {
            case let .failure(error):
                self.didUpdateViewState?(.hasError(error))
                
            case let .success(results):
                let serachResultViewEntity = SerachResultViewlEntity(repos: results.repos, pageInfo: results.pageInfo)
                self.didUpdateViewState?(.hasData(serachResultViewEntity))
                
                let pageInfo = results.pageInfo
                print("pageInfo: \n")
                print("hasNextPage: \(pageInfo.hasNextPage)")
                print("hasPreviousPage: \(pageInfo.hasPreviousPage)")
                print("startCursor: \(String(describing: pageInfo.startCursor))")
                print("endCursor: \(String(describing: pageInfo.endCursor))")
                print("\n")
                
                results.repos.forEach { repository in
                    print("Name: \(repository.name)")
                    print("Path: \(repository.url)")
                    print("Owner: \(repository.owner.login)")
                    print("avatar: \(repository.owner.avatarUrl)")
                    print("Stars: \(repository.stargazers.totalCount)")
                    print("Description: \(repository.description ?? "")")
                    print("\n")
                }
            }
        }
    }
}
