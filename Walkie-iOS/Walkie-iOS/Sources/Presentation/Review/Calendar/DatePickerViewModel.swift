//
//  DatePickerViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/10/25.
//

import SwiftUI

final class DatePickerViewModel: ViewModelable {
    enum Action {
        case willAppear
        case selectedDate(date: Date)
        case didTapPreviousMonth
        case didTapNextMonth
        case didTapSelectButton
    }
    
    struct State {
        var selectedDate: Date
        var selectedMonth: Date
        var daysInMonth: Int?
        var offset: Int = 0
        var nextMonthAvailable: Bool = false
    }
    
    @Published var state: State
    private let calendar = Calendar.current
    
    init(selectedDate: Date) {
        state = State(selectedDate: selectedDate, selectedMonth: selectedDate)
        (state.daysInMonth, state.offset) = generateDaysCount(in: state.selectedMonth)
    }
    
    func action(_ action: Action) {
        switch action {
        case .selectedDate(date: let date):
            if date.getDayViewTime() != .future {
                state.selectedDate = date
            }
        case .didTapPreviousMonth:
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: self.state.selectedMonth) ?? Date()
            state.selectedMonth = previousMonth
            (state.daysInMonth, state.offset) = generateDaysCount(in: previousMonth)
            state.nextMonthAvailable = true
            
        case .didTapNextMonth:
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: self.state.selectedMonth) ?? Date()
            let nextMonthOfNextMonth = calendar.date(byAdding: .month, value: 1, to: nextMonth) ?? Date()
            if nextMonth.getDayViewTime() != .future {
                state.selectedMonth = nextMonth
                (state.daysInMonth, state.offset) = generateDaysCount(in: nextMonth)
                state.nextMonthAvailable = nextMonthOfNextMonth.getDayViewTime() != .future
            } else {
                state.nextMonthAvailable = false
            }
        case .didTapSelectButton: break
        case .willAppear:
            (state.daysInMonth, state.offset) = generateDaysCount(in: state.selectedMonth)
        }
    }
    
    private func generateDaysCount(in month: Date) -> (days: Int, offset: Int) {
        let daysInMonth = calendar.range(of: .day, in: .month, for: month)?.count ?? 0
        
        let components = calendar.dateComponents([.year, .month], from: month)
        guard let firstDayOfMonth = calendar.date(from: components) else { return (days: daysInMonth, offset: 0) }
        
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        let offset = (weekday - 1) % 7
        
        return (days: daysInMonth, offset: offset)
    }
}
