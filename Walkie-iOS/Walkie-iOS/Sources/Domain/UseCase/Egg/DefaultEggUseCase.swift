//
//  DefaultEggUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class DefaultEggUseCase {
    
    // MARK: - Dependency
    
    private let eggRepository: EggRepository
    private let memberRepository: MemberRepository
    private let stepStatusStore: StepStatusStore
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggRepository: EggRepository, memberRepository: MemberRepository, stepStatusStore: StepStatusStore) {
        self.eggRepository = eggRepository
        self.memberRepository = memberRepository
        self.stepStatusStore = stepStatusStore
    }
}

extension DefaultEggUseCase: EggUseCase {
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<EggEntity, NetworkError> {
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
    func getEggsList() -> AnyPublisher<[(EggEntity, EggDetailEntity)], NetworkError> {
        eggRepository.getEggsList()
            .mapToNetworkError()
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError> {
        eggRepository.getEggDetail(eggId: eggId)
            .mapToNetworkError()
    }
    
    func patchEggStep(
        egg: EggEntity,
        step: Int
    ) -> AnyPublisher<Void, NetworkError> {
        eggRepository.patchEggStep(
            egg: egg,
            step: step,
            willHatch: false
        )
        .mapToNetworkError()
        
    }
}
