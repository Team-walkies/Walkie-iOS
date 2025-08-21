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
    private var continuousDay: Int = 0
    
    // Calendar
    private var kstCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        return cal
    }
    
    private func kstFormatter() -> DateFormatter {
        let f = DateFormatter()
        f.calendar = kstCalendar
        f.timeZone = kstCalendar.timeZone
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    private func kstStartOfDay(_ date: Date) -> Date {
        kstCalendar.startOfDay(for: date)
    }
    
    init(
        putHealthUseCase: PutHealthUseCase,
        getHealthContinueDayUseCase: GetHealthContinueDayUseCase,
        getHealthDetailUseCase: GetHealthDetailUseCase
    ) {
        self.putHealthUseCase = putHealthUseCase
        self.getHealthContinueDayUseCase = getHealthContinueDayUseCase
        self.getHealthDetailUseCase = getHealthDetailUseCase
    }
    
    enum Action {
        case viewWillAppear
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
        case .viewWillAppear:
            getHealthkitStep()
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
        let todayStringKST = kstFormatter().string(from: Date())
        let isToday = (dateString == todayStringKST)
        
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
        index: Int = 0
    ) {
        guard index < steps.count else { return }
        let item = steps[index]
        let request = HealthRequestDto(
            targetSteps: UserManager.shared.getTargetStep ?? 6000,
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
                    guard let self = self else { return }
                    if let next = self.nextDay(fromDayString: item.date) {
                        UserManager.shared.setHealthkitSendDate(next)
                    }
                    self.putHealth(steps, index: index + 1)
                }
            )
            .store(in: &cancellables)
    }
}

private extension HealthCareViewModel {
    
    func getHealthkitStep() {
        let cal = kstCalendar
        let startInclusive: Date = {
            if let saved = UserManager.shared.getHealthkitSendDate {
                return cal.startOfDay(for: saved)
            } else {
                var comp = cal.dateComponents([.year], from: Date())
                comp.month = 8; comp.day = 1
                return cal.startOfDay(for: cal.date(from: comp) ?? Date())
            }
        }()
        let endExclusive = cal.startOfDay(for: Date())
        
        guard startInclusive < endExclusive else { return }
        
        HealthKitManager.shared.getDailySteps(from: startInclusive) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let steps):
                dump(steps)
                guard !steps.isEmpty else { return }
                self.putHealth(steps)
            case .failure(let error):
                print("HealthKit fetch failed: \(error)")
            }
        }
    }
    
    func nextDay(fromDayString day: String) -> Date? {
        let f = kstFormatter()
        guard let date = f.date(from: day) else { return nil }
        return kstCalendar.date(byAdding: .day, value: 1, to: kstStartOfDay(date))
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
            return TargetStep(rawValue: UserManager.shared.getTargetStep ?? 6000) ?? .six
        } else {
            return TargetStep(rawValue: serverTarget ?? 6000) ?? .six
        }
    }
}
