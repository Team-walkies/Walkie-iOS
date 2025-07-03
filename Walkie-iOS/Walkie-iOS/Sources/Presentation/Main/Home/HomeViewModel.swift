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
    private let getEventEggUseCase: GetEventEggUseCase
    
    private var isUpdatingSteps = false
    
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case homeWillAppear
        case homeWillDisappear
        case homeAuthAllowTapped
        case homeAlarmCheck
        case showEventModal
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
    
    struct HomeAlarmState: Equatable {
        let isAlarmChecked: PermissionState
        
        static func == (lhs: HomeAlarmState, rhs: HomeAlarmState) -> Bool {
            return lhs.isAlarmChecked == rhs.isAlarmChecked
        }
    }
    
    struct HomeEventState: Equatable {
        let showEventEgg: Bool
        let dDay: Int
        
        static func == (lhs: HomeEventState, rhs: HomeEventState) -> Bool {
            return lhs.showEventEgg == rhs.showEventEgg &&
            lhs.dDay == rhs.dDay
        }
    }
    
    // view states
    
    enum HomeViewState: Equatable {
        case loading
        case loaded(HomePermissionState)
        case error
    }
    
    enum HomeViewAlarmState: Equatable {
        case loading
        case loaded(HomeAlarmState)
        case error
    }
    
    enum HomeStatsViewState: Equatable {
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
    
    enum EventEggViewState: Equatable {
        case loading
        case loaded(HomeEventState)
        case error(String)
    }
    
    @Published var state: HomeViewState = .loading
    @Published var homeAlarmState: HomeViewAlarmState = .loading
    @Published var homeStatsState: HomeStatsViewState = .loading
    @Published var homeCharacterState: HomeCharacterViewState = .loading
    @Published var homeHistoryViewState: HomeHistoryViewState = .loading
    @Published var stepState: StepViewState = .loading
    @Published var leftStepState: LeftStepViewState = .loading
    @Published var eventEggState: EventEggViewState = .loading
    @Published var shouldShowDeniedAlert: Bool = false
    
    private let pedometer = CMPedometer()
    private let locationManager = LocationManager.shared
    private let appCoordinator: AppCoordinator
    private let stepStatusStore: StepStatusStore
    private let remoteConfigManager: RemoteConfigManaging
    
    init(
        getEggPlayUseCase: GetEggPlayUseCase,
        getCharacterPlayUseCase: GetWalkingCharacterUseCase,
        getEggCountUseCase: GetEggCountUseCase,
        getCharactersCountUseCase: GetCharactersCountUseCase,
        getRecordedSpotUseCase: RecordedSpotUseCase,
        appCoordinator: AppCoordinator,
        stepStatusStore: StepStatusStore,
        remoteConfigManager: RemoteConfigManaging = RemoteConfigManager.shared,
        getEventEggUseCase: GetEventEggUseCase
    ) {
        self.getEggPlayUseCase = getEggPlayUseCase
        self.getCharacterPlayUseCase = getCharacterPlayUseCase
        self.getEggCountUseCase = getEggCountUseCase
        self.getCharactersCountUseCase = getCharactersCountUseCase
        self.getRecordedSpotUseCase = getRecordedSpotUseCase
        self.appCoordinator = appCoordinator
        self.stepStatusStore = stepStatusStore
        self.remoteConfigManager = remoteConfigManager
        self.getEventEggUseCase = getEventEggUseCase
        
        self.remoteConfigManager.configure(minimumFetchInterval: 0)
    }
    
    func action(_ action: Action) {
        switch action {
        case .homeWillAppear:
            checkPermission()
            subscribeToStepUpdate()
            updateLeftStep()
        case .homeWillDisappear:
            stopStepUpdates()
        case .homeAuthAllowTapped:
            showPermission()
        case .homeAlarmCheck:
            checkAlarm()
        case .showEventModal:
            Task { await activateRemoteConfig() }
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
        
        NotificationManager.shared.checkNotificationPermission { [weak self] notificationState in
            guard let self = self else { return }
            
            let notification = switch notificationState {
            case .denied: PermissionState.denied
            case .authorized: PermissionState.authorized
            default: PermissionState.notDetermined
            }
            
            let permissionState = HomePermissionState(
                isLocationChecked: locationState,
                isMotionChecked: motionState,
                isAlarmChecked: notification
            )
            
            DispatchQueue.main.async {
                if locationState == .authorized && motionState == .authorized { // 위치모션 허용됨
                    switch notification {
                    case .authorized: // 알림도 허용됨
                        self.state = .loaded(permissionState)
                    default: // 알림은 허용안됨
                        let alarmState = HomeAlarmState(
                            isAlarmChecked: notification
                        )
                        self.homeAlarmState = .loaded(alarmState)
                    }
                } else { // 위치모션 허용안됨
                    self.state = .loaded(permissionState)
                }
                
                if !self.isLocationNotDetermined() && !self.isMotionNotDetermined() {
                    self.getHomeAPI()
                }
            }
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
    
    func checkAlarm() {
        NotificationManager.shared.checkNotificationPermission { [weak self] notificationState in
            guard let self = self else { return }
            
            let notification = switch notificationState {
            case .denied: PermissionState.denied
            case .authorized: PermissionState.authorized
            default: PermissionState.notDetermined
            }
            
            let alarmState = HomeAlarmState(
                isAlarmChecked: notification
            )
            
            DispatchQueue.main.async {
                self.homeAlarmState = .loaded(alarmState)
            }
        }
    }
    
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
                    self.homeStatsState = .loaded(homeStatsState)
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
                            self.homeStatsState = .loaded(homeState)
                        default:
                            self.homeStatsState = .error("서버 오류")
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
    
    func getEventEgg() {
        getEventEggUseCase.getEventEgg()
            .walkieSink(
                with: self,
                receiveValue: { _, eventEggEntity in
                    let eventState = HomeEventState(
                        showEventEgg: eventEggEntity.canReceive,
                        dDay: eventEggEntity.dDay
                    )
                    Task { @MainActor in
                        self.eventEggState = .loaded(eventState)
                    }
                }, receiveFailure: { _, _ in
                }
            )
            .store(in: &cancellables)
    }
}

private extension HomeViewModel {
    
    func activateRemoteConfig() async {
        do {
            try await remoteConfigManager.fetchAndActivate()
            
            let eggEventEnabled = remoteConfigManager
                .boolValue(for: .eggEventEnabled)
            
            if eggEventEnabled { // event 기간
                let now = Date()
                let calendar = Calendar.current
                let oneDayAgo = calendar.date(
                    byAdding: .day, value: -1, to: now
                ) ?? now
                
                let lastDate = UserManager.shared.getLastVisitedDate
                ?? oneDayAgo
                
                let daysDiff = calendar.dateComponents(
                    [.day],
                    from: calendar.startOfDay(for: lastDate),
                    to: calendar.startOfDay(for: now)
                ).day ?? 0
                
                if daysDiff >= 1 { // 하루가 지났음 -> api 호출
                    getEventEgg()
                }
                UserManager.shared.setLastVisitedDate(now)
            }
        } catch {
            state = .error
        }
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
    
    func isLocationAlwaysAuthorized() -> Bool {
        let status = CLLocationManager().authorizationStatus
        return status == .authorizedAlways
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
                        self.homeStatsState = .loaded(homeState)
                        print("🏃 알 부화 이후 홈 업데이트 완료 🏃")
                    } else {
                        self.updateLeftStep()
                        print("🏃 홈 뷰모델 걸음 수 업데이트 완료 🏃")
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
            self.homeStatsState = .loaded(homeState)
            self.leftStepState = .loaded(LeftStepState(leftStep: 0))
        } else {
            self.leftStepState = .loaded(LeftStepState(leftStep: leftStep))
        }
    }
}
