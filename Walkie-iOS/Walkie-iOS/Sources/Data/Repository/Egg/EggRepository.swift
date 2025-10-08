//
//  EggRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol EggRepository {
    func getEggsList() -> AnyPublisher<[(EggEntity, EggDetailEntity)], NetworkError>
    func getEggDetail(eggId: Int) -> AnyPublisher<EggDetailEntity, NetworkError>
    func patchEggStep(egg: EggEntity, step: Int, willHatch: Bool) -> AnyPublisher<Void, NetworkError>
    func getEggsCount() -> AnyPublisher<Int, NetworkError>
    func getEventEgg() -> AnyPublisher<EventEggEntity, NetworkError>
    // FIXME: 서버 리스폰스 수정 요청
    func getHealthCareEggAward(latitude: Double, longitude: Double, dateString: String) -> AnyPublisher<EggType, NetworkError>
}
