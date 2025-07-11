//
//  WeekView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/11/25.
//

import SwiftUI
import WalkieCommon

struct WeekView: View {
    let selectedDayOfTheWeek: DayOfTheWeek // 선택한 요일
    let dates: [Date] // 일주일 Date
    let config: WeekViewConfig
    let onTap: (Date) -> Void
    
    private let cellWidth: CGFloat = 44 // 셀 너비(고정)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: (geometry.size.width - cellWidth * 7) / 6) {
                ForEach(dates, id: \.self) { date in
                    let cellConfig = cellConfiguration(for: date)
                    DayCell(
                        date: date,
                        isSelected: cellConfig.isSelected,
                        width: cellWidth,
                        height: cellConfig.height,
                        textColor: cellConfig.textColor,
                        backgroundColor: cellConfig.backgroundColor,
                        hasDot: cellConfig.hasDot
                    )
                    .onTapGesture {
                        onTap(date)
                    }
                }
            }
        }
    }
    
    private struct CellConfiguration {
        let isSelected: Bool
        let height: CGFloat
        let textColor: Color
        let backgroundColor: Color
        let hasDot: Bool
    }
    
    private func cellConfiguration(for date: Date) -> CellConfiguration {
        let isSelected = date.dayOfTheWeek == selectedDayOfTheWeek
        let (height, textColor, backgroundColor) = configuration(for: date, isSelected: isSelected)
        let hasDot = hasDot(for: date)
        
        return CellConfiguration(
            isSelected: isSelected,
            height: height,
            textColor: textColor,
            backgroundColor: backgroundColor,
            hasDot: hasDot
        )
    }
    
    private func configuration(for date: Date, isSelected: Bool) -> (height: CGFloat, textColor: Color, backgroundColor: Color) {
        switch config {
        case .spotReview:
            let height: CGFloat = 58
            let textColor: Color
            let backgroundColor: Color
            
            switch date.getDayViewTime() {
            case .past:
                textColor = isSelected ? .white : WalkieCommonAsset.gray700.swiftUIColor
                backgroundColor = isSelected ? WalkieCommonAsset.gray600.swiftUIColor : .white
            case .today:
                textColor = isSelected ? .white : WalkieCommonAsset.blue300.swiftUIColor
                backgroundColor = isSelected ? WalkieCommonAsset.blue300.swiftUIColor : .white
            case .future:
                textColor = WalkieCommonAsset.gray300.swiftUIColor
                backgroundColor = .white
            }
            return (height, textColor, backgroundColor)
            
        case .healthCare:
            let height: CGFloat = 50
            let textColor: Color
            let backgroundColor: Color
            
            switch date.getDayViewTime() {
            case .past:
                textColor = WalkieCommonAsset.gray700.swiftUIColor
                backgroundColor = isSelected ? WalkieCommonAsset.gray100.swiftUIColor : .white
            case .today:
                textColor = WalkieCommonAsset.blue400.swiftUIColor
                backgroundColor = isSelected ? WalkieCommonAsset.blue30.swiftUIColor : .white
            case .future:
                textColor = WalkieCommonAsset.gray300.swiftUIColor
                backgroundColor = .white
            }
            return (height, textColor, backgroundColor)
        }
    }
    
    private func hasDot(for date: Date) -> Bool {
        if case let .spotReview(hasSpotOn) = config {
            return hasSpotOn.contains { spotDate in
                Calendar.current.isDate(spotDate, inSameDayAs: date)
            }
        }
        return false
    }
}

extension WeekView {
    enum WeekViewConfig {
        case spotReview(hasSpotOn: [Date])
        case healthCare(stepData: [Date: (nowStep: Int, targetStep: Int)])
    }
}
