//
//  HomeViewModel.swift
//  Walkie-iOS
//
//  Created by ahra on 2/20/25.
//

import SwiftUI

import Combine
import CoreMotion
import CoreLocation

final class HomeViewModel: ViewModelable {
    
    // usecases
    
    private let getEggPlayUseCase: GetEggPlayUseCase
    private let getCharacterPlayUseCase: GetWalkingCharacterUseCase
    private let getEggCountUseCase: GetEggCountUseCase
    private let getCharactersCountUseCase: GetCharactersCountUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case homeWillAppear
        case homeWillDisappear
    }
    
    // states
    
    struct HomeStatsState {
        let hasEgg: Bool
        let eggImage, eggBackImage: ImageResource
    }
    
    struct HomeCharacterState {
        let characterImage: ImageResource
        let characterName: String
    }
    
    struct HomeHistoryState {
        let eggsCount, characterCount, spotCount: Int
    }
    
    struct StepState {
        let todayStep, leftStep: Int
        let todayDistance: Double
    }
    
    // view states
    
    enum HomeViewState {
        case loading
        case loaded
        case error
    }
    
    enum HomeStatsViewState {
        case loading
        case loaded(HomeStatsState)
        case error(String)
    }
    
    enum HomeCharacterViewState {
        case loading
        case loaded(HomeCharacterState)
        case error(String)
    }
    
    enum HomeHistoryViewState {
        case loading
        case loaded(HomeHistoryState)
        case error(String)
    }
    
    enum StepViewState {
        case loading
        case loaded(StepState)
        case error(StepState)
    }
    
    @Published var state: HomeViewState = .loading
    @Published var homeStatsState: HomeStatsViewState = .loading
    @Published var homeCharacterState: HomeCharacterViewState = .loading
    @Published var homeHistoryViewState: HomeHistoryViewState = .loading
    @Published var stepState: StepViewState = .loading
    
    private let pedometer = CMPedometer()
    private var needStep: Int = 0
    private let locationManager = LocationManager()
    
    init(
        getEggPlayUseCase: GetEggPlayUseCase,
        getCharacterPlayUseCase: GetWalkingCharacterUseCase,
        getEggCountUseCase: GetEggCountUseCase,
        getCharactersCountUseCase: GetCharactersCountUseCase
    ) {
        self.getEggPlayUseCase = getEggPlayUseCase
        self.getCharacterPlayUseCase = getCharacterPlayUseCase
        self.getEggCountUseCase = getEggCountUseCase
        self.getCharactersCountUseCase = getCharactersCountUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .homeWillAppear:
            fetchHomeStats()
            fetchHomeCharacter()
            fetchHomeHistory()
            locationManager.requestLocation()
        case .homeWillDisappear:
            stopStepUpdates()
        }
    }
    
    func fetchHomeStats() {
        
        getEggPlayUseCase.getEggPlaying()
            .walkieSink(
                with: self,
                receiveValue: { _, eggEntity in
                    let hasEgg: Bool = eggEntity.eggId >= 0
                    let homeStatsState = HomeStatsState(
                        hasEgg: hasEgg,
                        eggImage: hasEgg ? eggEntity.eggType.eggImage : .imgEggEmpty,
                        eggBackImage: hasEgg ? eggEntity.eggType.eggBackground : .imgEggBack0
                    )
                    self.homeStatsState = .loaded(homeStatsState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.homeStatsState = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchHomeCharacter() {
        
        getCharacterPlayUseCase.getCharacterWalking()
            .walkieSink(
                with: self,
                receiveValue: { _, characterEntity in
                    let img = characterEntity.type == .jellyfish
                    ? characterEntity.jellyfishType?.getCharacterImage()
                    : characterEntity.dinoType?.getCharacterImage()
                    let name = characterEntity.type == .jellyfish
                    ? characterEntity.jellyfishType?.rawValue
                    : characterEntity.dinoType?.rawValue
                    
                    let homeCharacterState = HomeCharacterState(
                        characterImage: img ?? .imgJellyfish0,
                        characterName: name ?? JellyfishType.defaultJellyfish.rawValue
                    )
                    self.homeCharacterState = .loaded(homeCharacterState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.homeCharacterState = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchHomeHistory() {
        
        getEggCountUseCase.getEggsCount()
            .combineLatest(
                self.getCharactersCountUseCase.getCharactersCount()
            )
            .walkieSink(
                with: self,
                receiveValue: { _, combinedData in
                    let (eggCount, characterCount) = combinedData
                    let homeHistoryState = HomeHistoryState(
                        eggsCount: eggCount,
                        characterCount: characterCount,
                        spotCount: 0 // todo - binding
                    )
                    self.homeHistoryViewState = .loaded(homeHistoryState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.homeHistoryViewState = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
        
        self.startStepUpdates()
    }
}

private extension HomeViewModel {
    
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
