//
//  EggUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol EggUseCase {
    func getEggPlaying() -> AnyPublisher<EggEntity, NetworkError>
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Void, NetworkError>
    func getEggsList() -> AnyPublisher<[EggEntity], NetworkError>
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError>
    func patchEggStep(eggId: Int, step: Int) -> AnyPublisher<Void, NetworkError>
    func getEggsCount() -> AnyPublisher<EggsCountEntity, NetworkError>
}
