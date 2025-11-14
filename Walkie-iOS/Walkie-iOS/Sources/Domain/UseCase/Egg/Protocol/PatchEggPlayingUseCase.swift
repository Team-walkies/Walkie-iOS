//
//  PatchEggPlayingUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Combine

protocol PatchEggPlayingUseCase {
    func execute(eggId: Int) -> AnyPublisher<EggEntity, NetworkError>
}
