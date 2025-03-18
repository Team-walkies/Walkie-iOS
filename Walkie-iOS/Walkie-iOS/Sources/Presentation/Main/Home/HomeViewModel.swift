//
//  HomeViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

import Combine

final class HomeViewModel: ViewModelable {
    
    private let homeUseCase: HomeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case homeWillAppear
    }
    
    struct HomeState {
        let needStep, nowStep: Int
        let distance: Double
        let eggImage: ImageResource
        let characterImage: ImageResource
        let characterName: String
        let eggsCount, characterCount: Int
    }
    
    enum HomeViewState {
        case loading
        case loaded(HomeState)
        case error(String)
    }
    
    @Published var state: HomeViewState = .loading
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .homeWillAppear:
            fetchHomeData()
        }
    }
    
    func fetchHomeData() {
        
        let eggsPlay = EggsPlayEntity.eggsPlayDummy()
        let charactersPlay = CharactersPlayEntity.charactersPlayDummy()
        let charactersCount = CharactersCountEntity.charactersCountDummy()
        
        let type = charactersPlay.characterType
        let characterClass = charactersPlay.characterClass
        guard let characterImage = CharacterType.getCharacterImage(type: type, characterClass: characterClass),
            let characterName = CharacterType.getCharacterName(
                type: type,
                characterClass: characterClass) else { return }
        self.homeUseCase.getEggCount()
            .walkieSink(
                with: self,
                receiveValue: { _, entity in
                    let homeState = HomeState(
                        needStep: eggsPlay.needStep,
                        nowStep: eggsPlay.nowStep,
                        distance: 6.4,
                        eggImage: ImageResource(name: "img_egg\(eggsPlay.eggID)", bundle: .main),
                        characterImage: characterImage,
                        characterName: characterName,
                        eggsCount: entity.eggsCount,
                        characterCount: charactersCount.charactersCount
                    )
                    self.state = .loaded(homeState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                })
            .store(in: &cancellables)
    }
}
