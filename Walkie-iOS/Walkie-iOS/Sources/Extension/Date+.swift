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
}
