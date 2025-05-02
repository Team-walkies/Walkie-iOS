//
//  DefaultCalendarUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/13/25.
//

import Foundation

final class DefaultCalendarUseCase: CalendarUseCase {
    private let calendar = Calendar.current
    
    // 캘린더 범위 설정 (전주의 일요일 ~ 다음주의 토요일)
    func setCalendarRange(baseDate: Date) -> (startDate: Date, endDate: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate)
        
        guard let startOfWeek = calendar.date(from: components) else {
            let today = Date()
            let fallbackStartOfWeek = calendar.date(
                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
            ) ?? today
            let previousWeekStart = calendar.date(
                byAdding: .day,
                value: -7,
                to: fallbackStartOfWeek
            ) ?? fallbackStartOfWeek
            let nextWeekEnd = calendar.date(byAdding: .day, value: 13, to: fallbackStartOfWeek) ?? fallbackStartOfWeek
            return (startDate: previousWeekStart, endDate: nextWeekEnd)
        }
        
        let previousWeekStart = calendar.date(byAdding: .day, value: -7, to: startOfWeek) ?? startOfWeek
        let nextWeekEnd = calendar.date(byAdding: .day, value: 13, to: startOfWeek) ?? startOfWeek        
        return (startDate: previousWeekStart, endDate: nextWeekEnd)
    }
    
    // 이벤트 데이터 설정 (리뷰 날짜 목록 기반)
    func setCalendarEventData(eventDates: [String], dayViewState: inout [DayViewState]) {
        for i in 0..<dayViewState.count {
            dayViewState[i].hasSpot = eventDates.contains(convertToDateString(dayViewState[i].date))
        }
    }
    
    // 주 단위 DayViewState 생성
    func setCalendarDayViewState(baseDate: Date, selectedDate: Date) -> [DayViewState] {
        var days: [DayViewState] = []
        let selectedDayOfWeek = calendar.component(.weekday, from: selectedDate)
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: baseDate) {
                let isSelected = calendar.component(.weekday, from: date) == selectedDayOfWeek
                days.append(DayViewState(
                    date: date,
                    isSelected: isSelected,
                    time: date.getDayViewTime(),
                    hasSpot: false
                ))
            }
        }
        
        return days
    }
    
    private func convertToDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
