//
//  DefaultGetCharactersDetailUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

final class DefaultGetCharactersDetailUseCase {
    
    // MARK: - Dependency
    
    private let characterRepository: CharacterRepository
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
}

extension DefaultGetCharactersDetailUseCase: GetCharactersDetailUseCase {
    func getCharactersObtainedDetail(characterId: CLong) -> AnyPublisher<[CharacterDetailEntity], NetworkError> {
        characterRepository.getCharactersDetail(dummy: true, characterId: characterId)
            .mapToNetworkError()
    }
}
