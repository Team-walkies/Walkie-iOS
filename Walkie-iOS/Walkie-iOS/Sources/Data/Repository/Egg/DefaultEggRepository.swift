//
//  DefaultEggRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class DefaultEggRepository {
    
    // MARK: - Dependency
    
    private let eggService: EggService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(eggService: EggService) {
        self.eggService = eggService
    }
}

extension DefaultEggRepository: EggRepository {
    
    func getEggsList() -> AnyPublisher<[EggEntity], NetworkError> {
        return eggService.getEggsList()
            .map { dto in
                dto.eggs.map { egg in
                    EggEntity(
                        eggId: egg.eggId,
                        eggType: EggType.from(number: egg.rank),
                        nowStep: egg.nowStep,
                        needStep: egg.needStep,
                        isWalking: egg.play,
                        detail: EggDetailEntity(
                            obtainedPosition: egg.obtainedPosition,
                            obtainedDate: egg.obtainedDate
                        ),
                        characterType: nil,
                        jellyFishType: nil,
                        dinoType: nil
                    )
                }
            }.mapToNetworkError()
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError> {
        return eggService.getEggDetail(eggId: eggId)
            .map { dto in
                EggDetailEntity(
                    obtainedPosition: dto.obtainedPosition,
                    obtainedDate: dto.obtainedDate
                )
            }
            .mapToNetworkError()
    }
    
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Void, NetworkError> {
        return eggService.patchEggStep(requestBody: requestBody)
            .map { _ in return }
            .mapToNetworkError()
    }
    
    func getEggsCount() -> AnyPublisher<Int, NetworkError> {
        return eggService.getEggsCount()
            .map { dto in
                return dto.eggCount
            }
            .mapToNetworkError()
    }
}
