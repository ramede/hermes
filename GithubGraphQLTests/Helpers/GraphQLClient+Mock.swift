import Apollo
import Foundation
@testable import GithubGraphQL

enum MockGraphQLError: Error {
  case queryTypeMismatch
}

struct MockGraphQLClient<Query: GraphQLQuery> {
  typealias ExpectedType = Query

  private let mockedResponse: ExpectedType.Data?

  init(response: ExpectedType.Data?) {
    self.mockedResponse = response
  }
}

extension MockGraphQLClient: GraphQLClient {
  func fetch<Query: GraphQLQuery>(
    query: Query,
    cachePolicy: CachePolicy,
    contextIdentifier: UUID?,
    queue: DispatchQueue,
    resultHandler: GraphQLResultHandler<Query.Data>?
  ) -> Cancellable {
    guard let response = self.mockedResponse else {
       resultHandler?(.failure(MockGraphQLError.queryTypeMismatch))
       return EmptyCancellable()
    }
    resultHandler?(
      Query.self == ExpectedType.self
        ? .success(.init(data: (response as! Query.Data), extensions: nil, errors: nil, source: .cache, dependentKeys: nil))
        : .failure(MockGraphQLError.queryTypeMismatch)
    )
    return EmptyCancellable()
  }
}
