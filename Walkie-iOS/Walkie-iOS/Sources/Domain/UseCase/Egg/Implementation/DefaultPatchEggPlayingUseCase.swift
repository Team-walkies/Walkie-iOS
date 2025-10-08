//
//  DefaultPatchEggPlayingUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Combine

final class DefaultPatchEggPlayingUseCase: BaseMemberUseCase, PatchEggPlayingUseCase {
    func execute(eggId: Int) -> AnyPublisher<EggEntity, NetworkError> {
        let data = memberRepository.patchEggPlaying(eggId: eggId)
            .mapToNetworkError()
        return data
            .handleEvents(receiveOutput: { entity in
                self.stepStatusStore.resetStepStatus()
                self.stepStatusStore.setNowStep(entity.nowStep)
                self.stepStatusStore.setNeedStep(entity.needStep)
            })
            .eraseToAnyPublisher()
    }
}
