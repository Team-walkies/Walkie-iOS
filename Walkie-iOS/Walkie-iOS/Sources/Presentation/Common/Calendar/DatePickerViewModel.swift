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
        let selectedDate: Date
        let selectedMonth: Date
        let daysInMonth: Int?
        let offset: Int
        let nextMonthAvailable: Bool
    }
    
    weak var delegate: DatePickerDelegate?
    @Published var state: State
    private let calendar = Calendar.current
    
    init(delegate: DatePickerDelegate?, selectedDate: Date) {
        self.delegate = delegate
        let generatedDays = Date.generateDaysCount(in: selectedDate)
        self.state = State(
            selectedDate: selectedDate,
            selectedMonth: selectedDate,
            daysInMonth: generatedDays.days,
            offset: generatedDays.offset,
            nextMonthAvailable: false
        )
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            handleWillAppear()
        case .selectedDate(let date):
            handleSelectedDate(date)
        case .didTapPreviousMonth:
            handlePreviousMonth()
        case .didTapNextMonth:
            handleNextMonth()
        case .didTapSelectButton:
            handleSelectButton()
        }
    }
    
    // MARK: - Action Handlers
    
    private func handleWillAppear() {
        let generatedDays = Date.generateDaysCount(in: state.selectedMonth)
        updateState(
            selectedDate: state.selectedDate,
            selectedMonth: state.selectedMonth,
            daysInMonth: generatedDays.days,
            offset: generatedDays.offset
        )
    }
    
    private func handleSelectedDate(_ date: Date) {
        if date.getDayViewTime() != .future {
            let generatedDays = Date.generateDaysCount(in: date)
            updateState(
                selectedDate: date,
                selectedMonth: date,
                daysInMonth: generatedDays.days,
                offset: generatedDays.offset
            )
        }
    }
    
    private func handlePreviousMonth() {
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: state.selectedMonth) ?? Date()
        let generatedDays = Date.generateDaysCount(in: previousMonth)
        updateState(
            selectedDate: state.selectedDate,
            selectedMonth: previousMonth,
            daysInMonth: generatedDays.days,
            offset: generatedDays.offset
        )
    }
    
    private func handleNextMonth() {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: state.selectedMonth) ?? Date()
        guard let nextMonthFirstDay = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: nextMonth
            )
        ) else {
            return
        }
        
        if nextMonthFirstDay.getDayViewTime() != .future {
            let generatedDays = Date.generateDaysCount(in: nextMonth)
            updateState(
                selectedDate: state.selectedDate,
                selectedMonth: nextMonth,
                daysInMonth: generatedDays.days,
                offset: generatedDays.offset
            )
        }
    }
    
    private func handleSelectButton() {
        delegate?.selectDate(self.state.selectedDate)
        delegate?.willCloseDatePicker()
    }
    
    // MARK: - Helper
    
    private func updateState(selectedDate: Date, selectedMonth: Date, daysInMonth: Int?, offset: Int) {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) ?? Date()
        guard let nextMonthFirstDay = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: nextMonth
            )
        ) else {
            state = State(
                selectedDate: selectedDate,
                selectedMonth: selectedMonth,
                daysInMonth: daysInMonth,
                offset: offset,
                nextMonthAvailable: false
            )
            return
        }
        
        state = State(
            selectedDate: selectedDate,
            selectedMonth: selectedMonth,
            daysInMonth: daysInMonth,
            offset: offset,
            nextMonthAvailable: nextMonthFirstDay.getDayViewTime() != .future
        )
    }
}
