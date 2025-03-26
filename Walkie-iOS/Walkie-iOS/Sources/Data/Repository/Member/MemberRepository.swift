//
//  MemberRepository.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

protocol MemberRepository {
    func getEggPlaying() -> AnyPublisher<EggEntity, NetworkError>
    func patchEggPlaying(eggId: Int) -> AnyPublisher<Void, NetworkError>
}
