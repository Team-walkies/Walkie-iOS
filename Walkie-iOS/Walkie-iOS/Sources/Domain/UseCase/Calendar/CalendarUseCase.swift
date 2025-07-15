//
//  CalendarUseCase.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/13/25.
//

import Foundation

protocol CalendarUseCase {
    func generateWeeks(baseDate: Date) -> (pastWeek: [Date], presentWeek: [Date], futureWeek: [Date])
}
