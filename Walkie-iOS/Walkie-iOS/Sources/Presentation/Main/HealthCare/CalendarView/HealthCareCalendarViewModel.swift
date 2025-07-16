//
//  HealthCareCalendarViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/16/25.
//

import Foundation

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
        case willShowDatePicker
        case willCloseDatePikcer
        case updateStepData([String: (nowStep: Int, targetStep: Int)])
    }
    
    var state: State
    
    private let calendarUseCase: CalendarUseCase
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
        
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
    }
    
    func action(_ action: Action) {
        switch action {
            
        case let .selectDate(date):
            if date.getDayViewTime() == .future {
                return
            }
            
            let (past, present, future) = calendarUseCase.generateWeeks(baseDate: date)
            
            self.state.pastWeek = past
            self.state.presentWeek = present
            self.state.futureWeek = future
            self.state.selectedDate = date
            self.state.scrollPosition = 0
            
        case .scrollToPast:
            let newSelected = self.state.selectedDate.adding(days: -7)
            let (past, present, future) = calendarUseCase.generateWeeks(baseDate: newSelected)
            
            self.state.pastWeek = past
            self.state.presentWeek = present
            self.state.futureWeek = future
            self.state.selectedDate = newSelected
            self.state.scrollPosition = 0
            
        case .scrollToFuture:
            let newSelected = self.state.selectedDate.adding(days: 7)
            let (past, present, future) = calendarUseCase.generateWeeks(baseDate: newSelected)
            
            self.state.pastWeek = past
            self.state.presentWeek = present
            self.state.futureWeek = future
            self.state.selectedDate = newSelected
            self.state.scrollPosition = 0
            
        case .willShowDatePicker:
            self.state.showDatePicker = true
        
        case .willCloseDatePikcer:
            self.state.showDatePicker = false
            
        case let .updateStepData(data):
            self.state.healthCareData = convertStepDataToDateKeys(data)
        }
    }
    
    private func convertStringDatesToDates(_ stringDates: [String]) -> [Date] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        return stringDates.compactMap { dateString in
            dateFormatter.date(from: dateString)
        }
    }
    
    private func convertStepDataToDateKeys(_ data: [String: (nowStep: Int, targetStep: Int)]) -> [Date: (nowStep: Int, targetStep: Int)] {
        var result: [Date: (nowStep: Int, targetStep: Int)] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        
        for (dateString, stepData) in data {
            if let date = dateFormatter.date(from: dateString) {
                result[date] = stepData
            }
        }
        
        return result
    }
}

// MARK: - DatePickerDelegate
extension HealthCareCalendarViewModel: DatePickerDelegate {
    func selectDate(_ date: Date) {
        action(.selectDate(date))
    }
    
    func willCloseDatePicker() {
        action(.willCloseDatePikcer)
    }
}
