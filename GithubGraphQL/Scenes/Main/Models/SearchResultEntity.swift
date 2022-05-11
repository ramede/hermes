//
//  SearchResultEntity.swift
//  GithubGraphQL
//
//  Created by Râmede on 11/05/22.
//  Copyright © 2022 test. All rights reserved.
//

struct SerachResultViewlEntity {
    let repos: [RepositoryDetails]
    let pageInfo: SearchRepositoriesQuery.Data.Search.PageInfo
}

