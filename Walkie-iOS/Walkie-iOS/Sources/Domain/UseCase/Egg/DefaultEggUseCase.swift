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
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggRepository: EggRepository, memberRepository: MemberRepository) {
        self.eggRepository = eggRepository
        self.memberRepository = memberRepository
    }
}

extension DefaultEggUseCase: EggUseCase {
    func getEggPlaying() -> AnyPublisher<EggEntity, NetworkError> {
        memberRepository.getEggPlaying()
            .map { dto in EggEntity(
                eggId: dto.eggId,
                eggType: EggLiterals.from(number: dto.rank),
                nowStep: dto.nowStep,
                needStep: dto.needStep,
                isWalking: true,
                detail: nil)
            }.mapToNetworkError()
    }
    
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Void, NetworkError> {
        memberRepository.patchEggPlaying(eggId: eggId)
            .map { _ in return }
            .mapToNetworkError()
    }
    
    func getEggsList() -> AnyPublisher<[EggEntity], NetworkError> {
        eggRepository.getEggsList()
            .map { dto in
                dto.eggs.map { egg in
                    EggEntity(
                        eggId: egg.eggId,
                        eggType: EggLiterals.from(number: egg.rank),
                        nowStep: egg.nowStep,
                        needStep: egg.needStep,
                        isWalking: egg.play,
                        detail: EggDetailEntity(
                            obtainedPosition: egg.obtainedPosition,
                            obtainedDate: egg.obtainedDate
                        )
                    )
                }
            }.mapToNetworkError()
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError> {
        eggRepository.getEggDetail(eggId: eggId)
            .map { dto in
                EggDetailEntity(
                    obtainedPosition: dto.obtainedPosition,
                    obtainedDate: dto.obtainedDate
                )
            }.mapToNetworkError()
    }
    
    func patchEggStep(eggId: Int, step: Int) -> AnyPublisher<Void, NetworkError> {
        eggRepository.getEggDetail(eggId: eggId)
            .map { _ in return }
            .mapToNetworkError()
    }
    
    func getEggsCount() -> AnyPublisher<EggsCountEntity, NetworkError> {
        eggRepository.getEggsCount()
            .map { dto in
                EggsCountEntity(eggsCount: dto.eggCount)
            }.mapToNetworkError()
    }
}
