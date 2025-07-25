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
import WalkieCommon

final class HomeViewModel: ViewModelable {
    
    // usecases
    
    private let getEggPlayUseCase: GetEggPlayUseCase
    private let getCharacterPlayUseCase: GetWalkingCharacterUseCase
    private let getEggCountUseCase: GetEggCountUseCase
    private let getCharactersCountUseCase: GetCharactersCountUseCase
    private let getRecordedSpotUseCase: RecordedSpotUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case homeWillAppear
        case homeWillDisappear
    }
    
    // states
    
    struct HomeStatsState: Equatable {
        let hasEgg: Bool
        let eggImage: ImageResource
        let eggGradientColors: [Color]
        let eggEffectImage: ImageResource?
        
        static func == (lhs: HomeStatsState, rhs: HomeStatsState) -> Bool {
            return lhs.hasEgg == rhs.hasEgg &&
            lhs.eggImage == rhs.eggImage &&
            lhs.eggGradientColors == rhs.eggGradientColors &&
            lhs.eggEffectImage == rhs.eggEffectImage
        }
    }
    
    struct HomeCharacterState {
        let characterImage: ImageResource
        let characterName: String
    }
    
    struct HomeHistoryState {
        let eggsCount, characterCount, spotCount: Int
    }
    
    struct StepState {
        let todayStep: Int
        let todayDistance: Double
        let locationAlwaysAuthorized: Bool
    }
    
    struct LeftStepState {
        let leftStep: Int
    }
    
    // view states
    
    enum HomeViewState: Equatable {
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
    
    enum LeftStepViewState {
        case loading
        case loaded(LeftStepState)
        case error(String)
    }
    
    @Published var state: HomeViewState = .loading
    @Published var homeCharacterState: HomeCharacterViewState = .loading
    @Published var homeHistoryViewState: HomeHistoryViewState = .loading
    @Published var stepState: StepViewState = .loading
    @Published var leftStepState: LeftStepViewState = .loading
    
    private let pedometer = CMPedometer()
    private let appCoordinator: AppCoordinator
    private let stepStatusStore: StepStatusStore
    
    init(
        getEggPlayUseCase: GetEggPlayUseCase,
        getCharacterPlayUseCase: GetWalkingCharacterUseCase,
        getEggCountUseCase: GetEggCountUseCase,
        getCharactersCountUseCase: GetCharactersCountUseCase,
        getRecordedSpotUseCase: RecordedSpotUseCase,
        appCoordinator: AppCoordinator,
        stepStatusStore: StepStatusStore
    ) {
        self.getEggPlayUseCase = getEggPlayUseCase
        self.getCharacterPlayUseCase = getCharacterPlayUseCase
        self.getEggCountUseCase = getEggCountUseCase
        self.getCharactersCountUseCase = getCharactersCountUseCase
        self.getRecordedSpotUseCase = getRecordedSpotUseCase
        self.appCoordinator = appCoordinator
        self.stepStatusStore = stepStatusStore
    }
    
    func action(_ action: Action) {
        switch action {
        case .homeWillAppear:
            getHomeAPI()
            subscribeToStepUpdate()
            updateLeftStep()
        case .homeWillDisappear:
            stopStepUpdates()
        }
    }
}

// api
private extension HomeViewModel {
    
    func getHomeAPI() {
        fetchHomeStats()
        fetchHomeCharacter()
        fetchHomeHistory()
        startStepUpdates()
    }
    
    func fetchHomeStats() {
        
        getEggPlayUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, eggEntity in
                    let hasEgg: Bool = eggEntity.eggId >= 0
                    let homeStatsState = HomeStatsState(
                        hasEgg: hasEgg,
                        eggImage: hasEgg ? eggEntity.eggType.eggClipImage : .eggEmpty,
                        eggGradientColors: eggEntity.eggType.eggBackgroundColor,
                        eggEffectImage: eggEntity.eggType.eggBackEffect ?? nil
                    )
                    self.state = .loaded(homeStatsState)
                    self.leftStepState = .loaded(LeftStepState(leftStep: eggEntity.needStep - eggEntity.nowStep))
                }, receiveFailure: { _, error in
                    if let netErr = error {
                        switch netErr {
                        case .responseDecodingError:
                            let homeState = HomeStatsState(
                                hasEgg: false,
                                eggImage: .eggEmpty,
                                eggGradientColors: [
                                    WalkieCommonAsset.blue300.swiftUIColor,
                                    WalkieCommonAsset.blue200.swiftUIColor
                                ],
                                eggEffectImage: nil
                            )
                            self.state = .loaded(homeState)
                        default:
                            self.state = .error("서버 오류")
                        }
                    }
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
                self.getCharactersCountUseCase.getCharactersCount(),
                self.getRecordedSpotUseCase.getRecordedSpot()
            )
            .walkieSink(
                with: self,
                receiveValue: { _, combinedData in
                    let (eggCount, characterCount, spotCount) = combinedData
                    let homeHistoryState = HomeHistoryState(
                        eggsCount: eggCount,
                        characterCount: characterCount,
                        spotCount: spotCount
                    )
                    self.homeHistoryViewState = .loaded(homeHistoryState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.homeHistoryViewState = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
    }
}

private extension HomeViewModel {
    
    func startStepUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            DispatchQueue.main.async {
                self.stepState = .loaded(
                    StepState(
                        todayStep: 0,
                        todayDistance: 0,
                        locationAlwaysAuthorized: false
                    )
                )
            }
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        self.pedometer.queryPedometerData(from: startOfDay, to: now) { data, error in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    self.updateStepData(
                        step: data.numberOfSteps.intValue,
                        distance: (data.distance?.doubleValue ?? 0.0) / 1000.0
                    )
                } else {
                    self.updateStepData(step: -1, distance: 0)
                }
            }
        }
        
        self.pedometer.startUpdates(from: startOfDay) { data, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.updateStepData(
                        step: data.numberOfSteps.intValue,
                        distance: (data.distance?.doubleValue ?? 0.0) / 1000.0
                    )
                }
            }
        }
    }
    
    func isLocationAlwaysAuthorized() -> Bool {
        let status = CLLocationManager().authorizationStatus
        return status == .authorizedAlways
    }
    
    func updateStepData(step: Int, distance: Double) {
        self.stepState = .loaded(
            StepState(
                todayStep: step,
                todayDistance: distance,
                locationAlwaysAuthorized: isLocationAlwaysAuthorized()
            )
        )
    }
    
    func stopStepUpdates() {
        pedometer.stopUpdates()
        cancellables.removeAll() // 구독 취소
    }
    
    func subscribeToStepUpdate() {
        appCoordinator.stepCoordinator?.hatchPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("🏃 홈 뷰모델 걸음 수 업데이트 에러: \(error.localizedDescription) 🏃")
                }
            } receiveValue: { [weak self] isHatch in
                guard let self else { return }
                DispatchQueue.main.async {
                    if isHatch {
                        let homeState = HomeStatsState(
                            hasEgg: false,
                            eggImage: .eggEmpty,
                            eggGradientColors: [
                                WalkieCommonAsset.blue300.swiftUIColor,
                                WalkieCommonAsset.blue200.swiftUIColor
                            ],
                            eggEffectImage: nil
                        )
                        self.state = .loaded(homeState)
                    } else {
                        self.updateLeftStep()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func updateLeftStep() {
        let leftStep = stepStatusStore.getNeedStep() - stepStatusStore.getNowStep()
        if leftStep > 10000 {
            let homeState = HomeStatsState(
                hasEgg: false,
                eggImage: .eggEmpty,
                eggGradientColors: [
                    WalkieCommonAsset.blue300.swiftUIColor,
                    WalkieCommonAsset.blue200.swiftUIColor
                ],
                eggEffectImage: nil
            )
            self.state = .loaded(homeState)
            self.leftStepState = .loaded(LeftStepState(leftStep: 0))
        } else {
            self.leftStepState = .loaded(LeftStepState(leftStep: leftStep))
        }
    }
}
