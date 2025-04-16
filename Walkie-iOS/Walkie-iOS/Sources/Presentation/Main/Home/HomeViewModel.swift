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
        case homeAuthAllowTapped
        case homeAlarmAllowTapped
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
    
    struct HomePermissionState: Equatable {
        let isLocationChecked: PermissionState
        let isMotionChecked: PermissionState
        let isAlarmChecked: PermissionState
        
        static func == (lhs: HomePermissionState, rhs: HomePermissionState) -> Bool {
            return lhs.isLocationChecked == rhs.isLocationChecked &&
            lhs.isMotionChecked == rhs.isMotionChecked &&
            lhs.isAlarmChecked == rhs.isAlarmChecked
        }
    }
    
    // view states
    
    enum HomeViewState: Equatable {
        case loading
        case loaded(HomePermissionState)
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
    @Published var shouldShowDeniedAlert: Bool = false
    
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
            checkPermission()
        case .homeWillDisappear:
            stopStepUpdates()
        case .homeAuthAllowTapped:
            showPermission()
        default:
            break
        }
    }
    
    func checkPermission() {
        let locationState: PermissionState = {
            if isLocationNotDetermined() { return .notDetermined }
            if isLocationDenied() { return .denied }
            return .authorized
        }()
        let motionState: PermissionState = {
            if isMotionNotDetermined() { return .notDetermined }
            if isMotionDenied() { return .denied }
            return .authorized
        }()
        
        let permissionState = HomePermissionState(
            isLocationChecked: locationState,
            isMotionChecked: motionState,
            isAlarmChecked: .authorized // todo - binding
        )
        state = .loaded(permissionState)
        
        if !isLocationNotDetermined() && !isMotionNotDetermined() {
            getHomeAPI()
        }
    }
    
    func showPermission() {
        let locationNotDetermined = isLocationNotDetermined()
        let motionNotDetermined = isMotionNotDetermined()
        let locationDenied = isLocationDenied()
        let motionDenied = isMotionDenied()
        
        if locationNotDetermined || motionNotDetermined {
            locationManager.requestLocation()
            requestMotion()
            return
        }
        
        if locationDenied || motionDenied {
            shouldShowDeniedAlert = true
            return
        }
    }
    
    func getHomeAPI() {
        fetchHomeStats()
        fetchHomeCharacter()
        fetchHomeHistory()
        startStepUpdates()
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
    }
}

private extension HomeViewModel {
    
    func isLocationNotDetermined() -> Bool {
        let status = CLLocationManager().authorizationStatus
        return status == .notDetermined
    }
    
    func isMotionNotDetermined() -> Bool {
        guard CMMotionActivityManager.isActivityAvailable() else {
            return false
        }
        
        let status = CMMotionActivityManager.authorizationStatus()
        return status == .notDetermined
    }
    
    func isLocationAuthorized() -> Bool {
        let status = CLLocationManager().authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    func isMotionAuthorized() -> Bool {
        guard CMMotionActivityManager.isActivityAvailable() else {
            return false
        }
        
        let status = CMMotionActivityManager.authorizationStatus()
        return status == .authorized
    }
    
    func isLocationDenied() -> Bool {
        let status = CLLocationManager().authorizationStatus
        return status == .denied || status == .restricted
    }
    
    func isMotionDenied() -> Bool {
        guard CMMotionActivityManager.isActivityAvailable() else {
            return false
        }
        
        let status = CMMotionActivityManager.authorizationStatus()
        return status == .denied || status == .restricted
    }
    
    func requestMotion() {
        CMMotionActivityManager().startActivityUpdates(to: .main) { _ in }
        getHomeAPI()
    }
}

private extension HomeViewModel {
    
    func startStepUpdates() {
        guard CMPedometer.isStepCountingAvailable() else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        self.pedometer.queryPedometerData(from: startOfDay, to: now) { data, error in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    self.updateStepData(
                        step: data.numberOfSteps.intValue,
                        distance: (data.distance?.doubleValue ?? 0.0) / 1000.0
                    )
                } else { // 권한 거부인경우
                    self.updateStepData(step: -1, distance: 0)
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
