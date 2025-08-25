//
//  HealthCareCalendarViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/16/25.
//

import Foundation
import Combine

@Observable
final class HealthCareCalendarViewModel: ViewModelable {
    
    struct State {
        var pastWeek: [Date]
        var presentWeek: [Date]
        var futureWeek: [Date]
        var healthCareData: [Date: (nowStep: Int, targetStep: Int)]
        var selectedDate: Date
        var scrollPosition: Int?
        var showDatePicker: Bool = false
    }
    
    enum Action {
        case selectDate(Date)
        case scrollToPast
        case scrollToFuture
        case willCloseDatePicker
        case updateStepData([String: HealthWeekEntity])
    }
    
    var state: State
    
    private let calendarUseCase: CalendarUseCase
    private let getHealthUseCase: GetHealthUseCase
    private let appCoordinator: AppCoordinator
    private var cancellables = Set<AnyCancellable>()
    private let ymdKST: DateFormatter = Date.kstYMDFormatter()
    
    init(
        calendarUseCase: CalendarUseCase,
        getHealthUseCase: GetHealthUseCase,
        appCoordinator: AppCoordinator
    ) {
        self.calendarUseCase = calendarUseCase
        self.getHealthUseCase = getHealthUseCase
        self.appCoordinator = appCoordinator
        
        let today = Date()
        let (past, present, future) = calendarUseCase.generateWeeks(baseDate: today)
        
        self.state = .init(
            pastWeek: past,
            presentWeek: present,
            futureWeek: future,
            healthCareData: [:],
            selectedDate: today,
            scrollPosition: 0
        )
        
        requestVisibleWeeks()
    }
    
    func action(_ action: Action) {
        switch action {
            
        case let .selectDate(date):
            if date.getDayViewTime() == .future { return }
            let (past, present, future) = calendarUseCase.generateWeeks(baseDate: date)
            
            self.state.pastWeek = past
            self.state.presentWeek = present
            self.state.futureWeek = future
            self.state.selectedDate = date
            self.state.scrollPosition = 0
            requestVisibleWeeks()
        case .scrollToPast:
            let newSelected = self.state.selectedDate.adding(days: -7)
            let (past, present, future) = calendarUseCase.generateWeeks(baseDate: newSelected)
            
            self.state.pastWeek = past
            self.state.presentWeek = present
            self.state.futureWeek = future
            self.state.selectedDate = setSelectedDate(newSelected, in: present)
            self.state.scrollPosition = 0
            requestVisibleWeeks()
        case .scrollToFuture:
            let newSelected = self.state.selectedDate.adding(days: 7)
            let (past, present, future) = calendarUseCase.generateWeeks(baseDate: newSelected)
            
            self.state.pastWeek = past
            self.state.presentWeek = present
            self.state.futureWeek = future
            self.state.selectedDate = setSelectedDate(newSelected, in: present)
            self.state.scrollPosition = 0
            requestVisibleWeeks()
        case .willCloseDatePicker:
            self.appCoordinator.dismissSheet()
            
        case let .updateStepData(data):
            let converted = convertStepDataToDateKeys(data)
            state.healthCareData.merge(converted, uniquingKeysWith: { _, new in new })
        }
    }
    
    private func convertStepDataToDateKeys(
        _ data: [String: HealthWeekEntity]
    ) -> [Date: (nowStep: Int, targetStep: Int)] {
        var result: [Date: (nowStep: Int, targetStep: Int)] = [:]
        
        for (dateString, entity) in data {
            guard let parsed = Date.fromYMDKST(dateString) else { continue }
            let day = parsed.kstStartOfDay
            result[day] = (nowStep: entity.nowStep, targetStep: entity.targetStep)
        }
        
        return result
    }
    
    private func requestVisibleWeeks() {
        let today = Date().kstStartOfDay
        let yesterday = today.addingKST(days: -1)
        
        var weeks: [[Date]] = [state.pastWeek, state.presentWeek]
        if state.futureWeek.first?.getDayViewTime() != .future {
            weeks.append(state.futureWeek)
        }
        
        if state.presentWeek.contains(where: { $0.kstStartOfDay == today }) {
            addTodayStep()
        }
        
        guard
            let start = state.presentWeek.first?.kstStartOfDay,
            let endRaw = state.presentWeek.last?.kstStartOfDay
        else { return }
        
        let end = min(endRaw, yesterday)
        guard start <= today else { return }
        
        let dto = HealthDateDto(
            startDate: ymdKST.string(from: start),
            endDate: ymdKST.string(from: end)
        )
        getHealthWeek(dto: dto)
    }
    
    private func getHealthWeek(dto: HealthDateDto) {
        getHealthUseCase
            .getHealth(date: dto)
            .walkieSink(
                with: self,
                receiveValue: { [weak self] _, weekData in
                    guard let self = self else { return }
                    self.action(.updateStepData(weekData))
                }
            )
            .store(in: &cancellables)
    }
    
    private func addTodayStep() {
        let today = Date().kstStartOfDay
        let presentHasToday = state.presentWeek.contains { $0.kstStartOfDay == today }
        
        guard presentHasToday else { return }
        
        HealthKitManager.shared.getTodaySteps { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let todayData):
                self.state.healthCareData[today] = (
                    nowStep: todayData.steps,
                    targetStep: UserManager.shared.getTargetStep
                )
            case .failure:
                break
            }
        }
    }
    
    private func setSelectedDate(
        _ candidate: Date,
        in presentWeek: [Date]
    ) -> Date {
        let today = Date().kstStartOfDay
        let cand = candidate.kstStartOfDay
        
        let presentHasToday = presentWeek.contains { $0.kstStartOfDay == today }
        guard presentHasToday else { return cand }
        
        if cand > today { return today }
        
        let candInPresent = presentWeek.contains { $0.kstStartOfDay == cand }
        return candInPresent ? cand : today
    }
}

// MARK: - DatePickerDelegate
extension HealthCareCalendarViewModel: DatePickerDelegate {
    func selectDate(_ date: Date) {
        action(.selectDate(date))
    }
    
    func willCloseDatePicker() {
        action(.willCloseDatePicker)
    }
}
