//
//  Date+.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/7/25.
//

import Foundation

extension Date {
    
    // 현재 주를 기준으로 앞뒤 n주를 포함한 [Date] 반환
    static func datesByAddingWeeks(_ weeks: Int, from date: Date = Date()) -> [Date] {
        let calendar = Calendar.current
        // 현재 주의 첫 번째 날(일요일) 계산
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        guard let startOfCurrentWeek = calendar.date(from: components) else {
            return [date] // 기본값
        }
        
        // -n부터 +n까지의 주를 배열로 생성
        var weekDates: [Date] = []
        for offset in -weeks...weeks {
            if let weekDate = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfCurrentWeek) {
                weekDates.append(weekDate)
            }
        }
        return weekDates
    }
    
    // 주의 첫번째 날(일요일) 반환
    static func getFirstDayOfWeek(from date: Date = Date()) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        guard let sunday = calendar.date(from: components) else {
            return date
        }
        return sunday
    }
    
    // 요일을 DayOfTheWeek enum으로 반환
    var dayOfTheWeek: DayOfTheWeek {
        let weekday = Calendar.current.component(.weekday, from: self) - 1
        return DayOfTheWeek.allCases[weekday]
    }
    
    // 해당 날짜가 달의 몇 번째 날인지 반환
    var dayOfMonth: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    // 같은 날인지 반환
    func isSameDay(date: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)
        
        return components1.year == components2.year &&
        components1.month == components2.month &&
        components1.day == components2.day
    }
    
    // 오늘인지 반환
    func isToday() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let components1 = calendar.dateComponents([.year, .month, .day], from: today)
        let components2 = calendar.dateComponents([.year, .month, .day], from: self)
        
        return components1.year == components2.year &&
        components1.month == components2.month &&
        components1.day == components2.day
    }
    
    // 연도와 달 반환
    func getYearAndMonth() -> (year: Int, month: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return (year: components.year ?? 0, month: components.month ?? 0)
    }
    
    // 과거 현재 미래 반환
    func getDayViewTime() -> DayViewTime {
        let calendar = Calendar.current
        let today = Date()
        
        if self.isToday() {
            return .today
        }
        
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        let inputComponents = calendar.dateComponents([.year, .month, .day], from: self)
        
        guard
            let todayDate = calendar.date(from: todayComponents),
            let inputDate = calendar.date(from: inputComponents)
        else {
            return .today
        }
        
        return inputDate > todayDate ? .future : .past
    }
    
    // 달 별 일수 반환
    static func generateDaysCount(in month: Date) -> (days: Int, offset: Int) {
        let calendar = Calendar.current
        let daysInMonth = calendar.range(of: .day, in: .month, for: month)?.count ?? 0
        
        let components = calendar.dateComponents([.year, .month], from: month)
        guard let firstDayOfMonth = calendar.date(from: components) else { return (days: daysInMonth, offset: 0) }
        
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        let offset = (weekday - 1) % 7
        
        return (days: daysInMonth, offset: offset)
    }
    
    // 날짜 이동
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    // 날짜 형식 포맷팅
    func convertToDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
