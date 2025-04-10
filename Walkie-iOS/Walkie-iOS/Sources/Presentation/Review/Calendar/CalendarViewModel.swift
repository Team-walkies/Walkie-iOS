//
//  CalendarViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/10/25.
//

import SwiftUI

final class CalendarViewModel: ViewModelable {
    
    enum Action {
        case willSelectDate(_ at: Date)
        case didTapTodayButton
        case willScrollToPreviousWeek(_ at: Date)
        case willScrollToNextWeek(_ at: Date)
    }
    
    struct WeekState: Equatable {
        let selectedWeek: [DayViewState]
        let previousWeek: [DayViewState]
        let nextWeek: [DayViewState]
        
        static func == (lhs: WeekState, rhs: WeekState) -> Bool {
            return lhs.selectedWeek == rhs.selectedWeek &&
            lhs.previousWeek == rhs.previousWeek &&
            lhs.nextWeek == rhs.nextWeek
        }
    }
    
    struct CalendarState: Equatable {
        let selectedDate: Date
        let selectedDayOfTheWeek: DayOfTheWeek
        let selectedYearAndMonth: (year: Int, month: Int)
        
        static func == (lhs: CalendarState, rhs: CalendarState) -> Bool {
            return lhs.selectedDate == rhs.selectedDate &&
            lhs.selectedDayOfTheWeek == rhs.selectedDayOfTheWeek &&
            lhs.selectedYearAndMonth == rhs.selectedYearAndMonth
        }
    }
    
    // MARK: Properties
    @Published var state: CalendarState
    @Published var weekState: WeekState
    @Published var showPicker: Bool = false
    private let calendar = Calendar.current
    
    // MARK: Initializer
    init() {
        let today = Date()
        self.state = CalendarState(
            selectedDate: today,
            selectedDayOfTheWeek: today.dayOfTheWeek,
            selectedYearAndMonth: (year: 0, month: 0)
        )
        self.weekState = WeekState(
            selectedWeek: [],
            previousWeek: [],
            nextWeek: []
        )
        initializeState(from: today)
    }
    
    // MARK: Action
    func action(_ action: Action) {
        switch action {
        case .willSelectDate(let date):
            if date.getDayViewTime() != .future {
                if let startOfWeek = calendar.date(
                    from: calendar.dateComponents(
                        [.yearForWeekOfYear, .weekOfYear],
                        from: date
                    )
                ) {
                    updateWeekState(from: startOfWeek, selectedDate: date)
                    self.state = CalendarState(
                        selectedDate: date,
                        selectedDayOfTheWeek: date.dayOfTheWeek,
                        selectedYearAndMonth: startOfWeek.getYearAndMonth()
                    )
                }
            }
            showPicker = false
        case .didTapTodayButton:
            let today = Date()
            if let startOfWeek = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: today
                )
            ) {
                updateWeekState(from: startOfWeek, selectedDate: today)
                self.state = CalendarState(
                    selectedDate: today,
                    selectedDayOfTheWeek: today.dayOfTheWeek,
                    selectedYearAndMonth: startOfWeek.getYearAndMonth()
                )
            }
        case .willScrollToPreviousWeek(let date):
            handleWeekScroll(baseDate: date, offset: -7)
            
        case .willScrollToNextWeek(let date):
            handleWeekScroll(baseDate: date, offset: 7)
        }
    }
    
    // MARK: Private Methods
    
    private func initializeState(from date: Date) {
        if let startOfWeek = calendar.date(
            from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: date
            )
        ) {
            updateWeekState(from: startOfWeek, selectedDate: date)
            self.state = CalendarState(
                selectedDate: date,
                selectedDayOfTheWeek: date.dayOfTheWeek,
                selectedYearAndMonth: startOfWeek.getYearAndMonth()
            )
        }
    }
    
    private func handleWeekScroll(baseDate: Date, offset: Int) {
        guard let (newStart, newPrevious, newNext) = generateAdjacentWeeks(from: baseDate, offset: offset) else {
            return
        }
        
        self.weekState = WeekState(
            selectedWeek: generateWeekDays(from: newStart, selectedDate: state.selectedDate),
            previousWeek: generateWeekDays(from: newPrevious, selectedDate: state.selectedDate),
            nextWeek: generateWeekDays(from: newNext, selectedDate: state.selectedDate)
        )
        self.state = CalendarState(
            selectedDate: state.selectedDate,
            selectedDayOfTheWeek: state.selectedDayOfTheWeek,
            selectedYearAndMonth: newStart.getYearAndMonth()
        )
    }
    
    private func updateWeekState(from startOfWeek: Date, selectedDate: Date) {
        let newPrevious = calendar.date(byAdding: .day, value: -7, to: startOfWeek) ?? startOfWeek
        let newNext = calendar.date(byAdding: .day, value: 7, to: startOfWeek) ?? startOfWeek
        self.weekState = WeekState(
            selectedWeek: generateWeekDays(from: startOfWeek, selectedDate: selectedDate),
            previousWeek: generateWeekDays(from: newPrevious, selectedDate: selectedDate),
            nextWeek: generateWeekDays(from: newNext, selectedDate: selectedDate)
        )
    }
    
    private func generateAdjacentWeeks(
        from date: Date,
        offset: Int
    ) -> (
        start: Date,
        previous: Date,
        next: Date
    )? {
        let calendar = Calendar.current
        
        guard
            let newStart = calendar.date(byAdding: .day, value: offset, to: date),
            let newPrevious = calendar.date(byAdding: .day, value: offset - 7, to: date),
            let newNext = calendar.date(byAdding: .day, value: offset + 7, to: date)
        else {
            return nil
        }
        
        return (newStart, newPrevious, newNext)
    }
    
    private func generateWeekDays(from startDate: Date, selectedDate: Date) -> [DayViewState] {
        var days: [DayViewState] = []
        let selectedDayOfWeek = calendar.component(.weekday, from: selectedDate) // 선택된 날짜의 요일 번호 (1: 일요일, 2: 월요일, ...)
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                // 같은 요일인지 확인
                let isSelected = calendar.component(.weekday, from: date) == selectedDayOfWeek
                days.append(DayViewState(
                    date: date,
                    isSelected: isSelected,
                    time: date.getDayViewTime(),
                    hasSpot: true
                ))
            }
        }
        
        return days
    }
}
