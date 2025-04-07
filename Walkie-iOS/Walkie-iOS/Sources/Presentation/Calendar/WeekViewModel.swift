//
//  WeekViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/7/25.
//

import SwiftUI

final class WeekViewModel: ViewModelable {
    
    enum WeekViewState {
        case loading
        case loaded(WeekState)
        case error(String)
    }
    
    struct WeekState {
        // 날짜 선택에 필요
        var selectedDate: Date
        var selectedDayOfWeek: DayOfTheWeek
        // n년 n월 표시에 필요
        var firstDayOfWeek: Date
        // 무한 로딩에 필요
        var currentOffset: Int
        var loadedDays: [Date]
    }
    
    enum Action {
        case loadInitialDays
        case shouldLoadMoreDates(_ firstDayOfWeek: Date)
        case selectDay(_ date: Date)
        case offsetChanged(_ at: Int)
        case didTapCalendarButton
        case shouldUpdateDay(_ of: Date)
    }
    
    @Published var state: WeekViewState = .loading
    @Published var weekState: WeekState = .init(
        selectedDate: Date(),
        selectedDayOfWeek: Date().dayOfTheWeek,
        firstDayOfWeek: Date.getFirstDayOfWeek(),
        currentOffset: 0,
        // 앞뒤로 10주 생성
        loadedDays: Date.datesByAddingWeeks(10)
    )
    
    func action(_ action: Action) {
        
    }
}
