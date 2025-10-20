//
//  HealthCareViewModel.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/14/25.
//

import SwiftUI

import Combine

final class HealthCareViewModel: ViewModelable {
    
    private var cancellables = Set<AnyCancellable>()
    private let putHealthUseCase: PutHealthUseCase
    private let getHealthContinueDayUseCase: GetHealthContinueDayUseCase
    private let getHealthDetailUseCase: GetHealthDetailUseCase
    private let getHealthLastDataDayUseCase: GetHealthLastDataDayUseCase
    private var continuousDay: Int = 0
    
    init(
        coordinator: Coordinator,
        putHealthUseCase: PutHealthUseCase,
        getHealthContinueDayUseCase: GetHealthContinueDayUseCase,
        getHealthDetailUseCase: GetHealthDetailUseCase,
        getHealthLastDataDayUseCase: GetHealthLastDataDayUseCase
    ) {
        self.coordinator = coordinator
        self.putHealthUseCase = putHealthUseCase
        self.getHealthContinueDayUseCase = getHealthContinueDayUseCase
        self.getHealthDetailUseCase = getHealthDetailUseCase
        self.getHealthLastDataDayUseCase = getHealthLastDataDayUseCase
    }
    
    enum Action {
        case viewWillAppear(onDone: () -> Void)
        case selectDateChanged(dateString: String)
    }
    
    // states
    
    struct HealthCareInfoState {
        let continuousDays: Int
        let targetSteps: TargetStep
        let nowSteps: Int
        let nowDistance: Double
        let nowCalories: Int
        let isToday: Bool
        let eggButtonState: GetEggButtonState
    }
    
    struct HealthCareCalorieState {
        let caloriesName: String
        let caloriesDescription: String
        let caloriesImg: Image
    }
    
    private struct DetailSnapshot {
        let steps: Int
        let distance: Double
        let calories: Int?
        let isToday: Bool
        let serverTarget: Int?
        let awardState: GetEggButtonState
    }
    
    // view states
    
    enum HealthCareInfoViewState {
        case loading
        case loaded(HealthCareInfoState)
        case error
    }
    
    enum HealthCareCalorieViewState {
        case loading
        case loaded(HealthCareCalorieState)
        case error
    }
    
    var coordinator: Coordinator
    @Published var state: HealthCareInfoViewState = .loading
    @Published var calorieState: HealthCareCalorieViewState = .loading
    
    func action(_ action: Action) {
        switch action {
        case .viewWillAppear(let onDone):
            getHealthkitStep(completion: onDone)
        case .selectDateChanged(let dateString):
            load(dateString: dateString)
        }
    }
}

// api
private extension HealthCareViewModel {
    
    func load(dateString: String) {
        Task { @MainActor in
            do {
                async let day: Int = {
                    do {
                        return try await getHealthContinueDayUseCase
                            .getHealthContinueDay()
                            .firstOutput()
                    } catch OutputError.noOutput {
                        return 0
                    }
                }()
                
                async let detail: DetailSnapshot = fetchDetail(for: dateString)
                
                let (continuous, snapshot) = try await (day, detail)
                
                self.continuousDay = continuous
                self.applyHealthUpdate(
                    steps: snapshot.steps,
                    distance: snapshot.distance,
                    calories: snapshot.calories,
                    isToday: snapshot.isToday,
                    serverTarget: snapshot.serverTarget,
                    awardState: snapshot.awardState
                )
            } catch {
                self.state = .error
                self.calorieState = .error
            }
        }
    }
    
    private func fetchDetail(
        for dateString: String
    ) async throws -> DetailSnapshot {
        let isToday = Date.fromYMDKST(dateString)?.isTodayKST ?? false
        let detail: HealthDetailEntity?
        do {
            detail = try await getHealthDetailUseCase
                .getHealthDetail(searchDate: dateString)
                .firstOutput()
        } catch {
            detail = nil
        }
        
        if isToday {
            let today = try await HealthKitManager.shared.getTodaySteps()
            return DetailSnapshot(
                steps: today.steps,
                distance: today.distance,
                calories: nil,
                isToday: true,
                serverTarget: nil,
                awardState: detail?.eggButtonState ?? .pending
            )
        } else {
            guard let detail = detail else {
                return DetailSnapshot(
                    steps: 0,
                    distance: 0,
                    calories: nil,
                    isToday: false,
                    serverTarget: nil,
                    awardState: .pending
                )
            }
            return DetailSnapshot(
                steps: detail.nowSteps,
                distance: detail.nowDistance,
                calories: detail.nowCalories,
                isToday: false,
                serverTarget: detail.targetSteps,
                awardState: detail.eggButtonState
            )
        }
    }
    
    func putHealth(
        _ steps: [HealthKitManager.DailySteps],
        completion: @escaping () -> Void
    ) {
        guard !steps.isEmpty else {
            DispatchQueue.main.async { completion() }
            return
        }
        var iterator = steps.makeIterator()
        
        func uploadNext() {
            guard let item = iterator.next() else {
                DispatchQueue.main.async { completion() }
                return
            }
            let request = HealthRequestDto(
                targetSteps: UserManager.shared.getTargetStep,
                nowSteps: item.steps,
                nowCalories: item.steps / 30,
                nowDistance: item.distance,
                nowDay: item.date
            )
            putHealthUseCase
                .putHealth(request: request)
                .walkieSink(
                    with: self,
                    receiveValue: { [weak self] _, _ in
                        guard self != nil else { return }
                        uploadNext()
                    },
                    receiveFailure: { [weak self] _, _ in
                        guard self != nil else { return }
                        DispatchQueue.main.async { completion() }
                    }
                )
                .store(in: &cancellables)
        }
        uploadNext()
    }
}

private extension HealthCareViewModel {
    
    func getHealthkitStep(completion: @escaping () -> Void = {}) {
        getHealthLastDataDayUseCase
            .getHealthLastDataDay()
            .receive(on: DispatchQueue.main)
            .walkieSink(
                with: self,
                receiveValue: { [weak self] _, start in
                    guard let self else { return }
                    let endExclusive = Date().kstStartOfDay
                    guard start < endExclusive else {
                        completion()
                        return
                    }
                    
                    HealthKitManager.shared.getDailySteps(from: start.addingKST(days: 1)) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let steps):
                            guard !steps.isEmpty else {
                                DispatchQueue.main.async { completion() }
                                return
                            }
                            self.putHealth(steps) {
                                DispatchQueue.main.async { completion() }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async { completion() }
                            print("HealthKit fetch failed: \(error)")
                        }
                    }
                },
                receiveFailure: { [weak self] _, _ in
                    guard self != nil else { return }
                    DispatchQueue.main.async { completion() }
                }
            )
            .store(in: &cancellables)
    }
    
    func applyHealthUpdate(
        steps: Int,
        distance: Double,
        calories: Int?,
        isToday: Bool,
        serverTarget: Int?,
        awardState: GetEggButtonState
    ) {
        let target: TargetStep = resolveTargetStep(isToday: isToday, serverTarget: serverTarget)
        let displayContinuousDay = (isToday && steps >= target.rawValue)
        ? (self.continuousDay + 1)
        : self.continuousDay
        let buttonState = resolveEggButtonState(
            isToday: isToday,
            isGoalAchieve: steps >= target.rawValue,
            awardState: awardState
        )
        
        let info = HealthCareInfoState(
            continuousDays: displayContinuousDay,
            targetSteps: target,
            nowSteps: steps,
            nowDistance: distance,
            nowCalories: calories ?? steps / 30,
            isToday: isToday,
            eggButtonState: buttonState
        )
        self.state = .loaded(info)
        
        let calType = HealthCareCalorie.from(steps: steps)
        self.calorieState = .loaded(
            HealthCareCalorieState(
                caloriesName: calType.calorieName,
                caloriesDescription: calType.calorieDescription,
                caloriesImg: calType.calorieImage
            )
        )
    }
    
    func resolveTargetStep(isToday: Bool, serverTarget: Int?) -> TargetStep {
        if isToday {
            return TargetStep(rawValue: UserManager.shared.getTargetStep) ?? .six
        } else {
            return TargetStep(rawValue: serverTarget ?? 6000) ?? .six
        }
    }
    
    func resolveEggButtonState(
        isToday: Bool, // 오늘,과거 여부
        isGoalAchieve: Bool, // 달성여부
        awardState: GetEggButtonState // 서버에서 받아온 enum
    ) -> GetEggButtonState {
        if isToday {
            if isGoalAchieve { // 오늘 목표 달성
                return awardState == .received ? .received : .available
            } else { // 오늘 목표 미달성
                return awardState
            }
        } else { // 과거
            return awardState
        }
    }
    
    private func giveEgg(at dateString: String) {
        Task {
            do {
                // TODO:  API 호출을 통해 알 타입 전달
                let type: EggType = .epic // FIXME: 실제 리스폰스로 변경
                self.coordinator.presentFullScreenCover(
                    AppFullScreenCover.healthCareGiveEgg(type: type)
                )
            } catch {
                dump(error)
            }
        }
    }
}
