//
//  Date+.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/7/25.
//

import Foundation

extension Date {
    
    // 요일을 DayOfTheWeek enum으로 반환
    var dayOfTheWeek: DayOfTheWeek {
        let weekday = Date.kstCalendar.component(.weekday, from: self) - 1
        return DayOfTheWeek.allCases[weekday]
    }
    
    // 해당 날짜가 달의 몇 번째 날인지 반환
    var dayOfMonth: Int {
        return Date.kstCalendar.component(.day, from: self)
    }
    
    // 같은 날인지 반환
    func isSameDay(date: Date) -> Bool {
        Date.kstCalendar.isDate(self, inSameDayAs: date)
    }
    
    // 오늘인지 반환
    func isToday() -> Bool {
        Date.kstCalendar.isDateInToday(self)
    }
    
    // 연도와 달 반환
    func getYearAndMonth() -> (year: Int, month: Int) {
        let components = Date.kstCalendar.dateComponents([.year, .month], from: self)
        return (year: components.year ?? 0, month: components.month ?? 0)
    }
    
    // 과거 현재 미래 반환
    func getDayViewTime() -> TimePeriod {
        if self.isToday() {
            return .today
        }
        
        let todayStart = Date().kstStartOfDay
        let inputStart = self.kstStartOfDay
        
        return inputStart > todayStart ? .future : .past
    }
    
    // 달 별 일수 반환
    static func generateDaysCount(in month: Date) -> (days: Int, offset: Int) {
        let daysInMonth = Date.kstCalendar.range(of: .day, in: .month, for: month)?.count ?? 0
        
        let components = Date.kstCalendar.dateComponents([.year, .month], from: month)
        guard let firstDayOfMonth = Date.kstCalendar.date(from: components) else {
            return (days: daysInMonth, offset: 0)
        }
        
        let weekday = Date.kstCalendar.component(.weekday, from: firstDayOfMonth)
        let offset = (weekday - 1) % 7
        
        return (days: daysInMonth, offset: offset)
    }
    
    // 날짜 이동
    func adding(days: Int) -> Date {
        return Date.kstCalendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    // kst
    static let kstTimeZone: TimeZone = {
        TimeZone(identifier: "Asia/Seoul")
        ?? TimeZone(secondsFromGMT: 9 * 3600)
        ?? .current
    }()
    
    static var kstCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = kstTimeZone
        return cal
    }
    
    static func kstYMDFormatter() -> DateFormatter {
        let f = DateFormatter()
        f.calendar = kstCalendar
        f.timeZone = kstTimeZone
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    var kstStartOfDay: Date {
        Date.kstCalendar.startOfDay(for: self)
    }
    
    /// "yyyy-MM-dd"
    var ymdKST: String {
        Date.kstYMDFormatter().string(from: self)
    }
    
    /// 오늘인지
    var isTodayKST: Bool {
        Date.kstCalendar.isDateInToday(self)
    }
    
    /// 같은 날인지
    func isSameDayKST(with other: Date) -> Bool {
        Date.kstCalendar.isDate(self, inSameDayAs: other)
    }
    
    /// 날짜 이동
    func addingKST(days: Int) -> Date {
        Date.kstCalendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// "yyyy-MM-dd" -> Date
    static func fromYMDKST(_ string: String) -> Date? {
        Date.kstYMDFormatter().date(from: string)
    }
}
