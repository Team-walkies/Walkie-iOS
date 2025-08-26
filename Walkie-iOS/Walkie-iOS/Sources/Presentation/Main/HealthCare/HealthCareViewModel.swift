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
        putHealthUseCase: PutHealthUseCase,
        getHealthContinueDayUseCase: GetHealthContinueDayUseCase,
        getHealthDetailUseCase: GetHealthDetailUseCase,
        getHealthLastDataDayUseCase: GetHealthLastDataDayUseCase
    ) {
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
        continuousDayPublisher()
            .zip(detailPublisher(for: dateString))
            .receive(on: DispatchQueue.main)
            .walkieSink(
                with: self,
                receiveValue: { [weak self] _, zipped in
                    guard let self else { return }
                    let (day, detail) = zipped
                    self.continuousDay = day
                    self.applyHealthUpdate(
                        steps: detail.steps,
                        distance: detail.distance,
                        calories: detail.calories,
                        isToday: detail.isToday,
                        serverTarget: detail.serverTarget
                    )
                }
            )
            .store(in: &cancellables)
    }
    
    func continuousDayPublisher() -> AnyPublisher<Int, Error> {
        getHealthContinueDayUseCase
            .getHealthContinueDay()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func detailPublisher(
        for dateString: String
    ) -> AnyPublisher<DetailSnapshot, Error> {
        let isToday = (dateString == Date().ymdKST)
        
        if isToday {
            return Future<DetailSnapshot, Error> { promise in
                HealthKitManager.shared.getTodaySteps { result in
                    switch result {
                    case .success(let today):
                        promise(.success(.init(
                            steps: today.steps,
                            distance: today.distance,
                            calories: nil,
                            isToday: true,
                            serverTarget: nil
                        )))
                    case .failure(let e):
                        promise(.failure(e))
                    }
                }
            }
            .eraseToAnyPublisher()
        } else {
            return getHealthDetailUseCase
                .getHealthDetail(searchDate: dateString)
                .map { detail in
                    DetailSnapshot(
                        steps: detail.nowSteps,
                        distance: detail.nowDistance,
                        calories: detail.nowCalories,
                        isToday: false,
                        serverTarget: detail.targetSteps
                    )
                }
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
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
                    }
                )
                .store(in: &cancellables)
        }
        uploadNext()
    }
}

private extension HealthCareViewModel {
    
    func getHealthkitStep(completion: (() -> Void)? = nil) {
        getHealthLastDataDayUseCase
            .getHealthLastDataDay()
            .receive(on: DispatchQueue.main)
            .walkieSink(
                with: self,
                receiveValue: { [weak self] _, start in
                    guard let self else { return }
                    let endExclusive = Date().kstStartOfDay
                    guard start < endExclusive else {
                        completion?()
                        return
                    }
                    
                    HealthKitManager.shared.getDailySteps(from: start) { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(let steps):
                            guard !steps.isEmpty else {
                                completion?()
                                return
                            }
                            self.putHealth(steps) {
                                DispatchQueue.main.async { completion?() }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async { completion?() }
                            print("HealthKit fetch failed: \(error)")
                        }
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func nextDay(fromDayString day: String) -> Date? {
        guard let date = Date.fromYMDKST(day) else { return nil }
        return Date.kstCalendar.date(byAdding: .day, value: 1, to: date.kstStartOfDay)
    }
    
    func applyHealthUpdate(
        steps: Int,
        distance: Double,
        calories: Int?,
        isToday: Bool,
        serverTarget: Int?
    ) {
        let target: TargetStep = resolveTargetStep(isToday: isToday, serverTarget: serverTarget)
        let displayContinuousDay = (isToday && steps >= target.rawValue)
        ? (self.continuousDay + 1)
        : self.continuousDay
        
        let info = HealthCareInfoState(
            continuousDays: displayContinuousDay,
            targetSteps: target,
            nowSteps: steps,
            nowDistance: distance,
            nowCalories: calories ?? steps / 30,
            isToday: isToday
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
}
