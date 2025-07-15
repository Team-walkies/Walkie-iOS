//
//  DefaultCalendarUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/13/25.
//

import Foundation

final class DefaultCalendarUseCase: CalendarUseCase {
    func generateWeeks(baseDate: Date) -> (pastWeek: [Date], presentWeek: [Date], futureWeek: [Date]) {
        let calendar = Calendar.current
        // 기준 날짜의 자정(00:00)으로 설정
        let startOfDay = calendar.startOfDay(for: baseDate)
        
        // 현재 주의 일요일 찾기
        let components = calendar.dateComponents([.weekday], from: startOfDay)
        let weekday = components.weekday ?? 1 // 1: 일요일, 2: 월요일, ..., 7: 토요일
        let daysToSubtractForSunday = weekday - 1
        guard let currentSunday = calendar.date(byAdding: .day, value: -daysToSubtractForSunday, to: startOfDay) else {
            return ([], [], [])
        }
        
        // 과거 주, 현재 주, 미래 주의 시작 날짜(일요일)
        guard let pastSunday = calendar.date(byAdding: .day, value: -7, to: currentSunday),
              let futureSunday = calendar.date(byAdding: .day, value: 7, to: currentSunday) else {
            return ([], [], [])
        }
        
        // 각 주의 날짜 배열 생성 (일요일부터 토요일까지, 총 7일)
        var pastWeek: [Date] = []
        var presentWeek: [Date] = []
        var futureWeek: [Date] = []
        
        for day in 0..<7 {
            if let pastDay = calendar.date(byAdding: .day, value: day, to: pastSunday),
               let presentDay = calendar.date(byAdding: .day, value: day, to: currentSunday),
               let futureDay = calendar.date(byAdding: .day, value: day, to: futureSunday) {
                pastWeek.append(pastDay)
                presentWeek.append(presentDay)
                futureWeek.append(futureDay)
            }
        }
        
        return (pastWeek, presentWeek, futureWeek)
    }
}
