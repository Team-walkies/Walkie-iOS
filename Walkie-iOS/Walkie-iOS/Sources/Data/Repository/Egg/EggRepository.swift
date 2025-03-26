//
//  EggRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol EggRepository {
    func getEggsList(dummy: Bool) -> AnyPublisher<[EggEntity], NetworkError>
    func getEggDetail(dummy: Bool, eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError>
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Void, NetworkError>
    func getEggsCount() -> AnyPublisher<EggsCountEntity, NetworkError>
}
