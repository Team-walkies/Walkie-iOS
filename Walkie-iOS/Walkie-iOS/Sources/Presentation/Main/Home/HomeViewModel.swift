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
        let eggImage, eggBackImage: ImageResource
        let characterImage: ImageResource
        let characterName: String
        let eggsCount, characterCount, spotCount: Int
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
        case .homeWillDisappear:
            stopStepUpdates()
        }
    }
    
    func fetchHomeData() {
        
        self.homeUseCase.getEggCount()
            .combineLatest(
                self.homeUseCase.getCharacterPlay(),
                self.homeUseCase.getEggPlay()
            )
            .walkieSink(
                with: self,
                receiveValue: { _, combinedData in
                    
                    let (eggEntity, characterEntity, eggInfoEntity) = combinedData
                    
                    guard let characterImage = CharacterType.getCharacterImage(
                        type: characterEntity.characterType,
                        characterClass: characterEntity.characterClass
                    ), let characterName = CharacterType.getCharacterName(
                        type: characterEntity.characterType,
                        characterClass: characterEntity.characterClass)
                    else { return }
                    
                    self.needStep = eggInfoEntity.needStep
                    
                    let homeState = HomeState(
                        eggImage: eggInfoEntity.eggType.eggImage,
                        eggBackImage: eggInfoEntity.eggType.eggBackground,
                        characterImage: characterImage,
                        characterName: characterName,
                        eggsCount: eggEntity.eggsCount,
                        characterCount: 0, // todo - binding
                        spotCount: 0 // todo - binding
                    )
                    self.startStepUpdates()
                    self.state = .loaded(homeState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error((
                        HomeState(
                            eggImage: ImageResource(name: "img_egg0", bundle: .main),
                            eggBackImage: ImageResource(name: "img_eggBack0", bundle: .main),
                            characterImage: ImageResource(name: "img_jellyfish0", bundle: .main),
                            characterName: "",
                            eggsCount: 0,
                            characterCount: 0,
                            spotCount: 0
                        ), errorMessage
                    ))
                })
            .store(in: &cancellables)
    }
    
    func startStepUpdates() {
        guard CMPedometer.isStepCountingAvailable() else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        self.pedometer.queryPedometerData(from: startOfDay, to: now) { data, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.updateStepData(
                        step: data.numberOfSteps.intValue,
                        distance: (data.distance?.doubleValue ?? 0.0) / 1000.0)
                }
            }
        }
        
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
        let stepState = StepState(
            todayStep: step,
            leftStep: self.needStep - step,
            todayDistance: distance)
        self.stepState = .loaded(stepState)
    }
    
    func stopStepUpdates() {
        pedometer.stopUpdates()
    }
}
