//
//  DayViewState.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/10/25.
//

import SwiftUI

struct DayViewState: Identifiable, Equatable {
    let id: UUID = UUID()
    
    var date: Date
    var isSelected: Bool
    var time: DayViewTime
    var hasSpot: Bool
    
    static func == (lhs: DayViewState, rhs: DayViewState) -> Bool {
        return lhs.date.isSameDay(date: rhs.date) &&
               lhs.isSelected == rhs.isSelected &&
               lhs.time == rhs.time &&
               lhs.hasSpot == rhs.hasSpot
    }
}

enum DayViewTime: Equatable {
    case today
    case future
    case past
}
