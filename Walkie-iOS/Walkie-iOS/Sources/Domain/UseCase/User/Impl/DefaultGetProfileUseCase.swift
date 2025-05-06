//
//  DefaultGetProfileUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/5/25.
//

import Combine

final class DefaultGetProfileUseCase: BaseMemberUseCase, GetProfileUseCase {
    func execute() -> AnyPublisher<UserEntity, NetworkError> {
        memberRepository.getProfile()
            .mapToNetworkError()
    }
}
