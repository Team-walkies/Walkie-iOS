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
    
    func getEggsList(dummy: Bool = false) -> AnyPublisher<[EggEntity], NetworkError> {
        if dummy {
            let dummyData = (0..<20).map { eggId in
                EggEntity(
                    eggId: eggId,
                    eggType: EggLiterals.from(number: Int.random(in: 0...3)),
                    nowStep: Int.random(in: 0...5000),
                    needStep: Int.random(in: 1...5) * 1000,
                    isWalking: Bool.random(),
                    detail: nil
                )
            }
            return Just(dummyData)
                .setFailureType(to: Error.self)
                .mapToNetworkError()
        } else {
            return eggService.getEggsList()
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
    }
    
    func getEggDetail(dummy: Bool = false, eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError> {
        if dummy {
            let dummyData = EggDetailEntity(
                obtainedPosition: "부평구 삼산동",
                obtainedDate: "2023-04-15"
            )
            return Just(dummyData)
                .setFailureType(to: Error.self)
                .mapToNetworkError()
        } else {
            return eggService.getEggDetail(eggId: eggId)
                .map { dto in
                    EggDetailEntity(
                        obtainedPosition: dto.obtainedPosition,
                        obtainedDate: dto.obtainedDate
                    )
                }
                .mapToNetworkError()
        }
    }
    
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Void, NetworkError> {
        return eggService.patchEggStep(requestBody: requestBody)
            .map { _ in return }
            .mapToNetworkError()
    }
    
    func getEggsCount() -> AnyPublisher<EggsCountEntity, NetworkError> {
        return eggService.getEggsCount()
            .map { dto in EggsCountEntity(eggsCount: dto.eggCount)}
            .mapToNetworkError()
    }
}
