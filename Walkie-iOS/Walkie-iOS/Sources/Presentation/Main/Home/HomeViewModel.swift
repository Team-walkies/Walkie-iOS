//
//  HomeViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

import Combine

final class HomeViewModel: ViewModelable {
    
    enum Action {
        case homeWillAppear
    }
    
    struct HomeState {
        let needStep, nowStep, distance: Int
        let eggImage: ImageResource
        let characterImage: ImageResource
        let characterName: String
        let eggsCount: EggsCountResponse
        let characterCount: CharactersCountResponse
    }
    
    enum HomeViewState {
        case loading
        case loaded(HomeState)
        case error(String)
    }
    
    @Published var state: HomeViewState
    
    init() {
        state = .loading
    }
    
    func action(_ action: Action) {
        switch action {
        case .homeWillAppear:
            fetchHomeData()
        }
    }
    
    func fetchHomeData() {
        let eggsPlay = EggsPlayResponse.eggsPlayDummy()
        let charactersPlay = CharactersPlayResponse.charactersPlayDummy()
        let eggsCount = EggsCountResponse.eggsCountDummy()
        let charactersCount = CharactersCountResponse.charactersCountDummy()
        
        let type = charactersPlay.characterType
        let characterClass = charactersPlay.characterClass
        guard let characterImage = CharacterType.getCharacterImage(type: type,
                                                                   characterClass: characterClass) else { return }
        guard let characterName = CharacterType.getCharacterName(type: type,
                                                                 characterClass: characterClass) else { return }
        
        let homeState = HomeState(
            needStep: eggsPlay.needStep,
            nowStep: eggsPlay.nowStep,
            distance: 64,
            eggImage: ImageResource(name: "img_egg\(eggsPlay.eggID)", bundle: .main),
            characterImage: characterImage,
            characterName: characterName,
            eggsCount: eggsCount,
            characterCount: charactersCount
        )
        
        state = .loaded(homeState)
    }
}
