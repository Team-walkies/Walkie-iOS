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
    @Published var firstDay: Date
    @Published var lastDay: Date
    @Published var showPicker: Bool = false
    @ObservedObject var reviewViewModel: ReviewViewModel
    private let calendarUseCase: CalendarUseCase
    private let calendar = Calendar.current
    private var lastQuery: ReviewsCalendarDate?
    
    // MARK: Initializer
    init(reviewViewModel: ReviewViewModel, calendarUseCase: CalendarUseCase = DefaultCalendarUseCase()) {
        self.reviewViewModel = reviewViewModel
        self.calendarUseCase = calendarUseCase
        let today = Date()
        
        (self.firstDay, self.lastDay) = calendarUseCase.setCalendarRange(baseDate: today)
        
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

    private func initializeState(from date: Date) {
        if let startOfWeek = calendar.date(
            from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: date
            )
        ) {
            self.state = CalendarState(
                selectedDate: date,
                selectedDayOfTheWeek: date.dayOfTheWeek,
                selectedYearAndMonth: startOfWeek.getYearAndMonth()
            )
            handleWeekScroll(baseDate: startOfWeek, offset: 0, selectedDate: date)
        }
        lastQuery = .init(
            startDate: convertToDateString(self.firstDay),
            endDate: convertToDateString(self.lastDay)
        )
        updateSpotReviewState()
        showReviewList()
    }
    
    // MARK: Action
    func action(_ action: Action) {
        switch action {
        case .willSelectDate(let date):
            if date.getDayViewTime() != .future {
                self.state = CalendarState(
                    selectedDate: date,
                    selectedDayOfTheWeek: date.dayOfTheWeek,
                    selectedYearAndMonth: self.state.selectedYearAndMonth
                )
                (self.firstDay, self.lastDay) = calendarUseCase.setCalendarRange(baseDate: date)
                handleWeekScroll(baseDate: date, offset: 0, selectedDate: date)
                updateSpotReviewState()
                showReviewList()
            }
            showPicker = false
        case .didTapTodayButton:
            let today = Date()
            self.state = CalendarState(
                selectedDate: today,
                selectedDayOfTheWeek: today.dayOfTheWeek,
                selectedYearAndMonth: self.state.selectedYearAndMonth
            )
            (self.firstDay, self.lastDay) = calendarUseCase.setCalendarRange(baseDate: today)
            handleWeekScroll(baseDate: today, offset: 0, selectedDate: today)
            updateSpotReviewState()
            showReviewList()
        case .willScrollToPreviousWeek(let date):
            handleWeekScroll(baseDate: date, offset: -7, selectedDate: state.selectedDate)
            if let newStartOfWeek = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: date.adding(days: -7)
                )
            ) {
                (self.firstDay, self.lastDay) = calendarUseCase.setCalendarRange(baseDate: newStartOfWeek)
                let newSelectedWeek = calendarUseCase.setCalendarDayViewState(
                    baseDate: newStartOfWeek,
                    selectedDate: state.selectedDate
                )
                if let newSelectedDate = newSelectedWeek.first(
                    where: { $0.date.dayOfTheWeek == state.selectedDayOfTheWeek })?.date,
                    newSelectedDate.getDayViewTime() != .future {
                    self.state = CalendarState(
                        selectedDate: newSelectedDate,
                        selectedDayOfTheWeek: newSelectedDate.dayOfTheWeek,
                        selectedYearAndMonth: newStartOfWeek.getYearAndMonth()
                    )
                }
            }
            updateSpotReviewState()
            showReviewList()
        case .willScrollToNextWeek(let date):
            handleWeekScroll(baseDate: date, offset: 7, selectedDate: state.selectedDate)
            if let newStartOfWeek = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: date.adding(days: 7)
                )
            ) {
                (self.firstDay, self.lastDay) = calendarUseCase.setCalendarRange(baseDate: newStartOfWeek)
                let newSelectedWeek = calendarUseCase.setCalendarDayViewState(
                    baseDate: newStartOfWeek,
                    selectedDate: state.selectedDate
                )
                if let newSelectedDate = newSelectedWeek.first(
                    where: { $0.date.dayOfTheWeek == state.selectedDayOfTheWeek })?.date,
                    newSelectedDate.getDayViewTime() != .future {
                    self.state = CalendarState(
                        selectedDate: newSelectedDate,
                        selectedDayOfTheWeek: newSelectedDate.dayOfTheWeek,
                        selectedYearAndMonth: newStartOfWeek.getYearAndMonth()
                    )
                }
            }
            updateSpotReviewState()
            showReviewList()
        }
    }
    
    // 3주의 DayViewState 데이터 생성
    private func handleWeekScroll(baseDate: Date, offset: Int, selectedDate: Date) {
        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: baseDate
            )
        ) else { return }
        
        guard let (newStart, newPrevious, newNext) = generateAdjacentWeeks(from: startOfWeek, offset: offset) else {
            return
        }
        
        var newSelectedWeek = calendarUseCase.setCalendarDayViewState(
            baseDate: newStart,
            selectedDate: selectedDate
        )
        var newPreviousWeek = calendarUseCase.setCalendarDayViewState(
            baseDate: newPrevious,
            selectedDate: selectedDate
        )
        var newNextWeek = calendarUseCase.setCalendarDayViewState(
            baseDate: newNext,
            selectedDate: selectedDate
        )
        
        calendarUseCase.setCalendarEventData(
            eventDates: reviewViewModel.reviewDateList,
            dayViewState: &newSelectedWeek
        )
        calendarUseCase.setCalendarEventData(
            eventDates: reviewViewModel.reviewDateList,
            dayViewState: &newPreviousWeek
        )
        calendarUseCase.setCalendarEventData(
            eventDates: reviewViewModel.reviewDateList,
            dayViewState: &newNextWeek
        )
        
        self.weekState = WeekState(
            selectedWeek: newSelectedWeek,
            previousWeek: newPreviousWeek,
            nextWeek: newNextWeek
        )
        
        self.state = CalendarState(
            selectedDate: selectedDate,
            selectedDayOfTheWeek: selectedDate.dayOfTheWeek,
            selectedYearAndMonth: newStart.getYearAndMonth()
        )
    }
    
    // 3주의 날짜 생성
    private func generateAdjacentWeeks(from date: Date, offset: Int) -> (
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
    
    // 3주의 리뷰 API 요청
    private func updateSpotReviewState() {
        let query = ReviewsCalendarDate(
            startDate: convertToDateString(firstDay),
            endDate: convertToDateString(lastDay)
        )
        if let last = self.lastQuery, last.startDate != query.startDate {
            lastQuery = query
            reviewViewModel.action(.loadReviewList(startDate: query.startDate, endDate: query.endDate))
        }
    }
    
    // 선택한 날짜로 리뷰 필터링
    private func showReviewList() {
        let dateString = convertToDateString(state.selectedDate)
        reviewViewModel.action(.showReviewList(dateString: dateString))
    }
    
    func convertToDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
