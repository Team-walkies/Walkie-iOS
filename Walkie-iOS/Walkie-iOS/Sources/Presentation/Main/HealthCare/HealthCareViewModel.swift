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
            getHealthContinueDay()
        case .selectDateChanged(let dateString):
            getHealthDetail(dateString: dateString)
        }
    }
}

// api
private extension HealthCareViewModel {
    
    func getHealthContinueDay() {
        getHealthContinueDayUseCase
            .getHealthContinueDay()
            .walkieSink(
                with: self,
                receiveValue: { [weak self] _, day in
                    guard let self = self else { return }
                    continuousDay = day
                }
            )
            .store(in: &cancellables)
    }
    
    func getHealthDetail(dateString: String) {
        let isToday: Bool = (dateString == Date().convertToDateString())
        
        getHealthDetailUseCase
            .getHealthDetail(searchDate: dateString)
            .walkieSink(
                with: self,
                receiveValue: { [weak self] _, detail in
                    guard let self = self else { return }
                    let st = HealthCareInfoState(
                        continuousDays: continuousDay,
                        targetSteps: (
                            isToday
                            ? TargetStep(rawValue: detail.targetSteps)
                            : TargetStep(rawValue: UserManager.shared.getTargetStep ?? 6000)
                        ) ?? .six,
                        nowSteps: detail.nowSteps,
                        nowDistance: detail.nowDistance,
                        nowCalories: detail.nowCalories,
                        isToday: isToday
                    )
                    state = .loaded(st)
                    
                    let calorieType = HealthCareCalorie.from(steps: detail.nowSteps)
                    let calorieSt = HealthCareCalorieState(
                        caloriesName: calorieType.calorieName,
                        caloriesDescription: calorieType.calorieDescription,
                        caloriesImg: calorieType.calorieImage
                    )
                    calorieState = .loaded(calorieSt)
                }
            )
            .store(in: &cancellables)
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
        let cal = Calendar.current
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
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        
        let f = DateFormatter()
        f.calendar = cal
        f.timeZone = cal.timeZone
        f.dateFormat = "yyyy-MM-dd"
        
        guard let date = f.date(from: day) else { return nil }
        return cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: date))
    }
}
