//
//  HomeUseCase.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Combine

protocol HomeUseCase {
    
    // egg
    
    func getEggCount() -> AnyPublisher<EggsCountEntity, NetworkError>
    
    // member
    
    func getEggPlay() -> AnyPublisher<EggEntity, NetworkError>
    func getCharacterPlay() -> AnyPublisher<CharactersPlayEntity, NetworkError>
}
