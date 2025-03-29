//
//  DefaultGetCharactersListUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersListUseCase {
    
    // MARK: - Dependency
    
    private let characterRepository: CharacterRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
}

extension DefaultGetCharactersListUseCase: GetCharactersListUseCase {
    func getCharactersList() -> AnyPublisher<[CharacterEntity], NetworkError> {
        characterRepository.getCharactersList(dummy: true, type: .dino)
            .mapToNetworkError()
    }
}
