//
//  PermissionUseCase.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/8/25.
//

import Combine

protocol PermissionUseCase {
    func execute() -> AnyPublisher<HomePermissionState, Never>
    func requestAllIfNeeded() -> AnyPublisher<HomePermissionState, Never>
}
