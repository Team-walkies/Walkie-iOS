//
//  SpotCalendarViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/11/25.
//

import Foundation

@Observable
final class SpotCalendarViewModel: ViewModelable {
    struct State {
        var pastWeek: [Date]
        var presentWeek: [Date]
        var futureWeek: [Date]
        var hasSpotOn: [Date]
        var selectedDate: Date
        var scrollPosition: Int?
    }
    
    enum Action {
        case selectDate(Date)
        case scrollToPast
        case scrollToFuture
        case willCloseDatePicker
        case updateReviewDates([String])
    }
    
    var state: State
    
    private let calendarUseCase: CalendarUseCase
    private let appCoordinator: AppCoordinator
    
    init(calendarUseCase: CalendarUseCase, appCoordinator: AppCoordinator) {
        self.calendarUseCase = calendarUseCase
        self.appCoordinator = appCoordinator
        
        let today = Date()
        let (past, present, future) = calendarUseCase.generateWeeks(baseDate: today)
        
        self.state = .init(
            pastWeek: past,
            presentWeek: present,
            futureWeek: future,
            hasSpotOn: [],
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
            
        case .willCloseDatePicker:
            self.appCoordinator.dismissSheet()
            
        case let .updateReviewDates(dates):
            self.state.hasSpotOn = convertStringDatesToDates(dates)
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
}

// MARK: - DatePickerDelegate
extension SpotCalendarViewModel: DatePickerDelegate {
    func selectDate(_ date: Date) {
        action(.selectDate(date))
    }
    
    func willCloseDatePicker() {
        action(.willCloseDatePicker)
    }
}
