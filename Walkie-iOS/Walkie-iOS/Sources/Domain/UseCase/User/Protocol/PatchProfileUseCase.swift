//
//  PatchProfileUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/5/25.
//

import Combine

protocol PatchProfileUseCase {
    func patchProfileNickname(nickname: String) -> AnyPublisher<Void, NetworkError>
    func patchProfileVisibility() -> AnyPublisher<Void, NetworkError>
}
