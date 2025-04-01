//
//  CharacterViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/28/25.
//

import Combine

final class CharacterViewModel: ViewModelable {
    
    private let getCharactersListUseCase: GetCharactersListUseCase
    private let getCharactersDetailUseCase: GetCharactersDetailUseCase
    private let patchWalkingCharacterUseCase: PatchWalkingCharacterUseCase
    private var cancellables = Set<AnyCancellable>()

    enum CharacterViewState {
        case loading
        case loaded(CharacterListState)
        case error(String)
    }
    
    struct CharacterListState {
        let jellyfishState: [JellyfishType: CharacterState]
        let dinoState: [DinoType: CharacterState]
    }

    struct CharacterState {
        let characterId: Int
        let count: Int
        let isWalking: Bool
    }
    
    enum Action {
        case willAppear
        case willSelectCategory(CharacterType)
        case willSelectJellyfish(type: JellyfishType, state: CharacterState)
        case willSelectDino(type: DinoType, state: CharacterState)
        case fetchData
    }
    
    @Published var state: CharacterViewState
    @Published var showingCharacterType: CharacterType? = .jellyfish
    @Published var listState = CharacterListState(
        jellyfishState: Dictionary(
            uniqueKeysWithValues: JellyfishType.allCases.map {
                ($0, CharacterState(characterId: 0, count: 0, isWalking: false))
            }
        ), dinoState: Dictionary(
            uniqueKeysWithValues: DinoType.allCases.map {
                ($0, CharacterState(characterId: 0, count: 0, isWalking: false))
            }
        )
    )
    @Published var characterDetailViewModel: CharacterDetailViewModel?
    
    init(
        getCharactersListUseCase: GetCharactersListUseCase,
        getCharactersDetailUseCase: GetCharactersDetailUseCase,
        patchWalkingCharacterUseCase: PatchWalkingCharacterUseCase) {
        self.getCharactersListUseCase = getCharactersListUseCase
        self.getCharactersDetailUseCase = getCharactersDetailUseCase
        self.patchWalkingCharacterUseCase = patchWalkingCharacterUseCase
        self.state = .loading
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear, .fetchData:
            fetchCharactersListData()
        case .willSelectCategory(let category):
            self.showingCharacterType = category
        case .willSelectJellyfish(let jellyfish, let characterState):
            self.characterDetailViewModel = .init(
                characterViewModel: self,
                detailState: CharacterDetailViewModel.CharacterDetailState(
                    characterId: characterState.characterId,
                    characterName: jellyfish.rawValue,
                    characterImage: jellyfish.getCharacterImage(),
                    characterDescription: "예시",
                    characterRank: jellyfish.getCharacterRank(),
                    characterCount: characterState.count,
                    isWalking: characterState.isWalking),
                getCharactersDetailUseCase: self.getCharactersDetailUseCase,
                patchWalkingCharacterUseCase: self.patchWalkingCharacterUseCase
            )
        case .willSelectDino(let dino, let characterState):
            self.characterDetailViewModel = .init(
                characterViewModel: self,
                detailState: CharacterDetailViewModel.CharacterDetailState(
                    characterId: characterState.characterId,
                    characterName: dino.rawValue,
                    characterImage: dino.getCharacterImage(),
                    characterDescription: "예시",
                    characterRank: dino.getCharacterRank(),
                    characterCount: characterState.count,
                    isWalking: characterState.isWalking),
                getCharactersDetailUseCase: self.getCharactersDetailUseCase,
                patchWalkingCharacterUseCase: self.patchWalkingCharacterUseCase
            )
        }
    }
    
    private func fetchCharactersListData() {
        getCharactersListUseCase.getCharactersList()
            .walkieSink(
                with: self,
                receiveValue: { _, entities in
                    var updatedJellyfishState = self.listState.jellyfishState
                    var updatedDinoState = self.listState.dinoState
                    
                    entities.forEach { entity in
                        switch entity.type {
                        case .jellyfish:
                            if let jellyfishType = entity.jellyfishType {
                                updatedJellyfishState[jellyfishType] = CharacterState(
                                    characterId: entity.characterId,
                                    count: entity.count,
                                    isWalking: entity.isWalking
                                )
                            }
                        case .dino:
                            if let dinoType = entity.dinoType {
                                updatedDinoState[dinoType] = CharacterState(
                                    characterId: entity.characterId,
                                    count: entity.count,
                                    isWalking: entity.isWalking
                                )
                            }
                        }
                    }
                    self.state = .loaded(
                        CharacterListState(
                            jellyfishState: updatedJellyfishState,
                            dinoState: updatedDinoState
                        )
                    )
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            ).store(in: &cancellables)
    }
}
