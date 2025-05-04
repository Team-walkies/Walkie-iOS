//
//  DefaultGetEggPlayUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/1/25.
//

import Combine

final class DefaultGetEggPlayUseCase: BaseMemberUseCase, GetEggPlayUseCase {
    
    func execute() -> AnyPublisher<EggEntity, NetworkError> {
        memberRepository.getEggPlaying()
            .mapToNetworkError()
    }
}
