//
//  ViewModelTests.swift
//  GithubGraphQLTests
//
//  Created by Râmede on 15/05/22.
//  Copyright © 2022 test. All rights reserved.
//

@testable import GithubGraphQL
import XCTest

final class ViewModelTests: XCTestCase {
    var sut: ViewModel!
    var repos: [RepositoryDetails] = []
    
    override func setUpWithError() throws {
        let mockedResponse = SearchRepositoriesQuery.Data(search: .init(
            pageInfo: .init(startCursor: "startCursor", endCursor: nil, hasNextPage: true, hasPreviousPage: false),
            edges: makeEdges(count: 3)
        ))
        sut = ViewModel(client: MockGraphQLClient<SearchRepositoriesQuery>(response: mockedResponse))
    }
    
    override func tearDownWithError() throws {
            
    }
    
    func waitForStateUpdate() {
        let queue: DispatchQueue = .main
        let expectation = self.expectation(description: #function)
        queue.async {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testViewModel_WhenSearchMethodWasCalled_ShouldRetrieveData() throws {
        sut.didUpdateViewState = { [weak self] viewModelState in
            guard let self = self else { return }
            switch viewModelState {
            case .hasData(let searchResultViewEntity):
                self.repos = searchResultViewEntity.repos
            default:
                break
            }
        }
        
        sut.search(phrase: "graphql")
        waitForStateUpdate()

        XCTAssert(repos.count > 0)
    }
    
    func testViewModel_WhenSearchWasCalled_ShouldDisplayAndHideLoading() throws {
        var loadingCallsCount = 0
        var loadingIsActive = false
        sut.didUpdateViewState = { viewModelState in
            switch viewModelState {
            case .isLoading(let isLoading):
                loadingCallsCount += 1
                loadingIsActive = isLoading
            default:
                break
            }
        }
        
        sut.search(phrase: "graphql")
        waitForStateUpdate()
        
        XCTAssertEqual(loadingCallsCount, 2)
        XCTAssert(!loadingIsActive)
    }

    func testViewModel_WhenSearchMethodReturnError_ShouldHandleError () throws {
        var didHandleError = false
        sut = ViewModel(client: MockGraphQLClient<SearchRepositoriesQuery>(response: nil))

        sut.didUpdateViewState = { viewModelState in
            switch viewModelState {
            case .hasError:
                didHandleError = true
            default:
                break
            }
        }

        sut.search(phrase: "graphql")
        waitForStateUpdate()

        XCTAssert(didHandleError)
    }

}
