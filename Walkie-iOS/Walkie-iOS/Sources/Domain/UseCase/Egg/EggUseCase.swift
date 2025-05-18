//
//  EggUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol EggUseCase {
    func patchEggPlaying(eggId: Int) -> AnyPublisher<EggEntity, NetworkError>
    func getEggsList() -> AnyPublisher<[(EggEntity, EggDetailEntity)], NetworkError>
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError>
    func patchEggStep(
        egg: EggEntity,
        step: Int,
        willHatch: Bool
    ) -> AnyPublisher<Void, NetworkError>
}
