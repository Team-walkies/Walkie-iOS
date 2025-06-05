//
//  DefaultGetEggPlayUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 4/1/25.
//

import Combine

final class DefaultGetEggPlayUseCase: BaseMemberUseCase, GetEggPlayUseCase {
    
    func execute() -> AnyPublisher<EggEntity, NetworkError> {
        let data = memberRepository.getEggPlaying()
            .mapToNetworkError()
        return data
            .handleEvents(receiveOutput: { entity in
                print("알 걸음 수 초기화 완료")
                self.stepStatusStore.setNeedStep(entity.needStep)
            })
            .eraseToAnyPublisher()
    }
}
