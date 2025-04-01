//
//  BaseCharacterUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/30/25.
//

import Combine

class BaseCharactersUseCase {
    
    // MARK: - Dependency
    
    let characterRepository: CharacterRepository
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
}
