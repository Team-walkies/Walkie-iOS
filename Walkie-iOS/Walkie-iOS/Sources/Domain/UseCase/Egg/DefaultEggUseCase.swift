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
    private let stepStore: StepStore
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggRepository: EggRepository, memberRepository: MemberRepository) {
        self.eggRepository = eggRepository
        self.memberRepository = memberRepository
        self.stepStore = DefaultStepStore()
    }
}

extension DefaultEggUseCase: EggUseCase {
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<EggEntity, NetworkError> {
        let data = memberRepository.patchEggPlaying(eggId: eggId)
            .mapToNetworkError()
        return data
            .handleEvents(receiveOutput: { entity in
                // 목표치 초기화
                UserManager.shared.setStepCountGoal(entity.needStep)
                // 현재 걸음 수 초기화
                UserManager.shared.setStepCount(entity.nowStep)
                // 캐시 초기화
                self.stepStore.resetStepCountCache()
                // 걸음 수 업데이트 대상 알 변경
                StepManager.shared.changeEggPlaying(egg: entity)
            })
            .eraseToAnyPublisher()
    }
    func getEggsList() -> AnyPublisher<[EggEntity], NetworkError> {
        eggRepository.getEggsList()
            .mapToNetworkError()
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError> {
        eggRepository.getEggDetail(eggId: eggId)
            .mapToNetworkError()
    }
    
    func patchEggStep(
        egg: EggEntity,
        step: Int,
        willHatch: Bool = false
    ) -> AnyPublisher<Void, NetworkError> {
        eggRepository.patchEggStep(
            egg: egg,
            step: step,
            willHatch: willHatch
        )
        .mapToNetworkError()
        .handleEvents(receiveOutput: { entity in
            // 현재 걸음 수 초기화
            UserManager.shared.setStepCount(step)
            // 캐시 초기화
            self.stepStore.resetStepCountCache()
        })
        .eraseToAnyPublisher()
    }
}
