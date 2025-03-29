//
//  CharacterViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/28/25.
//

import SwiftUI

final class CharacterViewModel: ViewModelable {
    
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
        let count: Int
        let isWalking: Bool
    }
    
    enum Action {
        case willAppear
        case willSelectCategory(CharacterType)
        case willSelectJellyfish(type: JellyfishType, state: CharacterState)
        case willSelectDino(type: DinoType, state: CharacterState)
    }
    
    @Published var state: CharacterViewState = .loading
    @Published var showingCharacterType: CharacterType? = .jellyfish
    @Published var characterDetailViewModel: CharacterDetailViewModel?
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            let jellyfishState: [JellyfishType: CharacterState] = [
                .defaultJellyfish: CharacterState(count: 5, isWalking: false),
                .red: CharacterState(count: 3, isWalking: true),
                .green: CharacterState(count: 8, isWalking: true),
                .purple: CharacterState(count: 2, isWalking: false),
                .pink: CharacterState(count: 4, isWalking: true),
                .bunny: CharacterState(count: 1, isWalking: false),
                .starfish: CharacterState(count: 6, isWalking: true),
                .shocked: CharacterState(count: 0, isWalking: false),
                .strawberry: CharacterState(count: 7, isWalking: true),
                .space: CharacterState(count: 9, isWalking: false)
            ]
            
            let dinoState: [DinoType: CharacterState] = [
                .defaultDino: CharacterState(count: 5, isWalking: false),
                .red: CharacterState(count: 2, isWalking: true),
                .mint: CharacterState(count: 6, isWalking: true),
                .purple: CharacterState(count: 3, isWalking: false),
                .pink: CharacterState(count: 5, isWalking: true),
                .gentle: CharacterState(count: 1, isWalking: false),
                .pancake: CharacterState(count: 7, isWalking: true),
                .nessie: CharacterState(count: 0, isWalking: false),
                .melonSoda: CharacterState(count: 8, isWalking: true),
                .dragon: CharacterState(count: 10, isWalking: false)
            ]
            self.state = .loaded(CharacterListState(jellyfishState: jellyfishState, dinoState: dinoState))
        case .willSelectCategory(let category):
            self.showingCharacterType = category
        case .willSelectJellyfish(let jellyfish, let characterState):
            characterDetailViewModel = CharacterDetailViewModel(
                detailState: CharacterDetailViewModel.CharacterDetailState(
                    characterName: jellyfish.rawValue,
                    characterImage: jellyfish.getCharacterImage(),
                    characterDescription: "예시",
                    characterRank: jellyfish.getCharacterRank(),
                    characterCount: 0,
                    isWalking: false
                )
            )
        case .willSelectDino(let dino, let characterState):
            characterDetailViewModel = CharacterDetailViewModel(
                detailState: CharacterDetailViewModel.CharacterDetailState(
                    characterName: dino.rawValue,
                    characterImage: dino.getCharacterImage(),
                    characterDescription: "예시",
                    characterRank: dino.getCharacterRank(),
                    characterCount: 0,
                    isWalking: false
                )
            )
        }
    }
}
