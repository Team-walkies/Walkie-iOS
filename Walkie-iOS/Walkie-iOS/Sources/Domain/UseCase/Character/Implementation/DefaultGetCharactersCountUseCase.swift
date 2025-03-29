//
//  DefaultGetCharactersCountUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersCountUseCase {
    
    // MARK: - Dependency
    
    private let characterRepository: CharacterRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
}

extension DefaultGetCharactersCountUseCase: GetCharactersCountUseCase {
    func getCharactersCount() -> AnyPublisher<Int, NetworkError> {
        characterRepository.getCharactersCount(dummy: true)
            .mapToNetworkError()
    }
}
