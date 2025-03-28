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
        let category: CharacterType
        let jellyFishCount: [JellyfishType.AllCases: CharacterState]
        let dinoCount: [DinoType.AllCases: CharacterState]
    }
    
    struct CharacterState {
        let count: Int
        let isWalking: Bool
    }
    
    enum Action {
        case willAppear
        case willSelectCategory(CharacterType)
        case willSelectJellyFish(JellyfishType)
        case willSelectDino(DinoType)
    }
    
    @Published var state: CharacterViewState = .loading
    @Published var characterDetailViewModel: CharacterDetailViewModel?
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            <#code#>
        case .willSelectCategory(let category):
            <#code#>
        case .willSelectJellyFish(let jellyFish):
            <#code#>
        case .willSelectDino(let dino):
            <#code#>
        }
    }
}
