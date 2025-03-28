//
//  CharacterDetailViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/28/25.
//

import Foundation

final class CharacterDetailViewModel: ViewModelable {
    
    enum CharacterDetailViewState {
        case loading
        case loaded(CharacterDetailState)
        case error(String)
    }
    
    struct CharacterDetailState {
        let characterName: String
        let characterRank: EggType
        let characterCount: Int
        let obtainedList: [ObtainedState]
        let isWalking: Bool
    }
    
    struct ObtainedState {
        let obtainedDate: String
        let obtainedPosition: String
    }
    
    enum Action {
        case willAppear
        case didSelectCharacterWalking
    }
    
    @Published var state: CharacterDetailViewState = .loading
    @Published var detailState: CharacterDetailState?
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            <#code#>
        case .didSelectCharacterWalking:
            <#code#>
        }
    }
}
