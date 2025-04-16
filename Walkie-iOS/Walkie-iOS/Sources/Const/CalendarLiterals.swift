//
//  CalendarLiterals.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/7/25.
//

import Foundation

enum TimePeriod {
    case past
    case present
    case future
}

enum DayOfTheWeek: String, CaseIterable {
    case sunday = "일"
    case monday = "월"
    case tuesday = "화"
    case wednesday = "수"
    case thursday = "목"
    case friday = "금"
    case saturday = "토"
}
