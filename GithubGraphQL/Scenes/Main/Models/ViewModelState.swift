//
//  ViewModelState.swift
//  GithubGraphQL
//
//  Created by Râmede on 11/05/22.
//  Copyright © 2022 test. All rights reserved.
//

import Foundation

enum ViewModelState {
    case hasData(SerachResultViewlEntity)
    case hasError(Error)
    case isLoading(_ isLoading: Bool)
}
