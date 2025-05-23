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
    
    func getEggsList() -> AnyPublisher<[(EggEntity, EggDetailEntity)], NetworkError> {
        return eggService.getEggsList()
            .map { dto in
                dto.eggs.map { egg in
                    (
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
                        ),
                        EggDetailEntity(
                            obtainedPosition: egg.obtainedPosition,
                            obtainedDate: egg.obtainedDate
                        )
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
    
    func patchEggStep(
        egg: EggEntity,
        step: Int,
        willHatch: Bool = false
    ) -> AnyPublisher<Void, NetworkError> {
        if let location = LocationManager.shared.getCurrentLocation(), willHatch {
            eggService.patchEggStep(
                requestBody: .init(
                    eggId: egg.eggId,
                    nowStep: step,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            )
            .map { _ in return }
            .mapToNetworkError()
        } else {
            eggService.patchEggStep(
                requestBody: .init(
                    eggId: egg.eggId,
                    nowStep: step,
                    latitude: nil,
                    longitude: nil
                )
            )
            .map { _ in return }
            .mapToNetworkError()
        }
    }
    
    func getEggsCount() -> AnyPublisher<Int, NetworkError> {
        return eggService.getEggsCount()
            .map { dto in
                return dto.eggCount
            }
            .mapToNetworkError()
    }
}
