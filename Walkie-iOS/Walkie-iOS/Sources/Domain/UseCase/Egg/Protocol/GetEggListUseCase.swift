//
//  GetEggListUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Combine

protocol GetEggListUseCase {
    func execute() -> AnyPublisher<[(EggEntity, EggDetailEntity)], NetworkError>
}
