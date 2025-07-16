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
            HStack(alignment: .top, spacing: (geometry.size.width - cellWidth * 7) / 6) {
                ForEach(dates, id: \.self) { date in
                    let cellConfig = cellConfiguration(for: date)
                    VStack(alignment: .center, spacing: 0) {
                        DayCell(
                            date: date,
                            isSelected: cellConfig.isSelected,
                            width: cellWidth,
                            height: cellConfig.height,
                            textColor: cellConfig.textColor,
                            backgroundColor: cellConfig.backgroundColor,
                            hasDot: cellConfig.hasDot
                        )
                        if case let .healthCare(stepData) = config {
                            if let data = stepData[date] {
                                CircleProgressView(
                                    type: .inCalendar,
                                    targetStep: TargetStep(rawValue: data.targetStep) ?? .six,
                                    nowStep: data.nowStep
                                )
                            } else {
                                CircleProgressView(
                                    type: .inCalendar,
                                    targetStep: .six,
                                    nowStep: 0
                                )
                            }
                        }
                    }
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
    
    private func configuration(
        for date: Date,
        isSelected: Bool
    ) -> (
        height: CGFloat,
        textColor: Color,
        backgroundColor: Color
    ) {
        let timePeriod = date.getDayViewTime()
        let height = config.getHeight()
        let textColor = config.getTextColor(isSelected: isSelected, timePeriod: timePeriod)
        let backgroundColor = config.getBackgroundColor(isSelected: isSelected, timePeriod: timePeriod)
        
        return (height, textColor, backgroundColor)
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
        
        func getTextColor(isSelected: Bool, timePeriod: TimePeriod) -> Color {
            switch self {
            case .spotReview:
                switch timePeriod {
                case .past:
                    return isSelected ? .white : WalkieCommonAsset.gray700.swiftUIColor
                case .today:
                    return isSelected ? .white : WalkieCommonAsset.blue300.swiftUIColor
                case .future:
                    return WalkieCommonAsset.gray300.swiftUIColor
                }
            case .healthCare:
                switch timePeriod {
                case .past:
                    return WalkieCommonAsset.gray700.swiftUIColor
                case .today:
                    return WalkieCommonAsset.blue400.swiftUIColor
                case .future:
                    return WalkieCommonAsset.gray300.swiftUIColor
                }
            }
        }
        
        func getBackgroundColor(isSelected: Bool, timePeriod: TimePeriod) -> Color {
            switch self {
            case .spotReview:
                switch timePeriod {
                case .past:
                    return isSelected ? WalkieCommonAsset.gray600.swiftUIColor : .white
                case .today:
                    return isSelected ? WalkieCommonAsset.blue300.swiftUIColor : .white
                case .future:
                    return .white
                }
            case .healthCare:
                switch timePeriod {
                case .past:
                    return isSelected ? WalkieCommonAsset.gray100.swiftUIColor : .white
                case .today:
                    return isSelected ? WalkieCommonAsset.blue30.swiftUIColor : .white
                case .future:
                    return .white
                }
            }
        }
        
        func getHeight() -> CGFloat {
            switch self {
            case .spotReview:
                return 58
            case .healthCare:
                return 50
            }
        }
    }
}
