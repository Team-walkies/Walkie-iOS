//
//  HomeRepository.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Combine

protocol HomeRepository {
    
    func getEggCount() -> AnyPublisher<EggsCountEntity, Error>
}
