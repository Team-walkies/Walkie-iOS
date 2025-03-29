//
//  CharacterDetailViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/28/25.
//

import SwiftUI

final class CharacterDetailViewModel: ViewModelable {
    
    enum CharacterDetailViewState {
        case loading
        case loaded(obtainedState: [ObtainedState], detailState: CharacterDetailState)
        case error(String)
    }
    
    struct CharacterDetailState {
        let characterName: String
        let characterImage: ImageResource
        let characterDescription: String
        let characterRank: EggType
        let characterCount: Int
        let isWalking: Bool
    }
    
    struct ObtainedState: Hashable {
        let obtainedDate: String
        let obtainedPosition: String
    }
    
    enum Action {
        case willAppear
        case didSelectCharacterWalking
    }
    
    @Published var state: CharacterDetailViewState = .loading
    @Published var detailState: CharacterDetailState
    
    init(detailState: CharacterDetailState) {
        self.detailState = detailState
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchCharacterDetailData()
        case .didSelectCharacterWalking:
            patchCharacterWalking()
        }
    }
    
    private func fetchCharacterDetailData() {
        state = .loaded(
            obtainedState: Array(repeating: ObtainedState(
                obtainedDate: "abcabc",
                obtainedPosition: "1234"), count: 20),
            detailState: detailState
        )
    }
    
    private func patchCharacterWalking() {
        // API 호출
    }
}
