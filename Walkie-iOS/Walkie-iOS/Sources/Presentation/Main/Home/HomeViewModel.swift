//
//  HomeViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

import Combine
import CoreMotion

final class HomeViewModel: ViewModelable {
    
    private let homeUseCase: HomeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case homeWillAppear
        case homeWillDisappear
    }
    
    struct HomeState {
        let eggImage: ImageResource
        let characterImage: ImageResource
        let characterName: String
        let eggsCount, characterCount: Int
    }
    
    struct StepState {
        let todayStep, leftStep: Int
        let todayDistance: Double
    }
    
    enum HomeViewState {
        case loading
        case loaded(HomeState)
        case error((HomeState, String))
    }
    
    enum StepViewState {
        case loading
        case loaded(StepState)
        case error(StepState)
    }
    
    @Published var state: HomeViewState = .loading
    @Published var stepState: StepViewState = .loading
    
    private let pedometer = CMPedometer()
    private var needStep: Int = 0
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .homeWillAppear:
            fetchHomeData()
            startStepUpdates()
        case .homeWillDisappear:
            stopStepUpdates()
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
                        eggImage: ImageResource(name: "img_egg\(eggsPlay.eggID)", bundle: .main),
                        characterImage: characterImage,
                        characterName: characterName,
                        eggsCount: entity.eggsCount,
                        characterCount: charactersCount.charactersCount
                    )
                    self.state = .loaded(homeState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error((
                        HomeState(
                            eggImage: ImageResource(name: "img_egg0", bundle: .main),
                            characterImage: characterImage,
                            characterName: "",
                            eggsCount: 0,
                            characterCount: 0
                        ), errorMessage
                    ))
                })
            .store(in: &cancellables)
    }
    
    func startStepUpdates() {
        guard CMPedometer.isStepCountingAvailable() else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        self.pedometer.startUpdates(from: startOfDay) { data, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    let newStepData = data.numberOfSteps.intValue
                    let newDistanceData = (data.distance?.doubleValue ?? 0.0) / 1000.0
                    self.updateStepData(step: newStepData, distance: newDistanceData)
                }
            }
        }
    }
    
    func updateStepData(step: Int, distance: Double) {
        let eggsPlay = EggsPlayEntity.eggsPlayDummy()
        let stepState = StepState(
            todayStep: step,
            leftStep: eggsPlay.needStep - step,
            todayDistance: distance)
        self.stepState = .loaded(stepState)
    }
    
    func stopStepUpdates() {
        pedometer.stopUpdates()
    }
}
