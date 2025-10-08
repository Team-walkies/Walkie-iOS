//
//  GetHealthCareEggAwardUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 10/8/25.
//

import Combine

protocol GetHealthCareEggAwardUseCase {
    func execute(latitude: Double, longitude: Double, dateString: String) -> AnyPublisher<EggType, NetworkError>
}
