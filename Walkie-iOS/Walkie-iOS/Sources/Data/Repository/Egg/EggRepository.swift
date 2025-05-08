//
//  EggRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol EggRepository {
    func getEggsList() -> AnyPublisher<[EggEntity], NetworkError>
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError>
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Void, NetworkError>
    func getEggsCount() -> AnyPublisher<Int, NetworkError>
}
