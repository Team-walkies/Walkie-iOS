//
//  CalendarUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/13/25.
//

import Foundation

protocol CalendarUseCase {
    func setCalendarRange(baseDate: Date) -> (startDate: Date, endDate: Date)
    func setCalendarEventData(eventDates: [String], dayViewState: inout [DayViewState])
    func setCalendarDayViewState(baseDate: Date, selectedDate: Date) -> [DayViewState]
}
