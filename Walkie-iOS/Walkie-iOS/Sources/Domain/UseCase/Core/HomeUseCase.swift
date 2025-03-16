//
//  HomeUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Combine

protocol HomeUseCase {
    
    func getEggCount() -> AnyPublisher<EggsCountEntity, NetworkError>
}
