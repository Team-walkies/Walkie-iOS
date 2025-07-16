//
//  HealthCareWeekScrollView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/16/25.
//

import SwiftUI

struct HealthCareWeekScrollView: View {
    
    // 날짜 데이터
    let pastWeek: [Date]
    let presentWeek: [Date]
    let futureWeek: [Date]
    
    // 헬스케어 관련
    let selectedDate: Date
    let healthCareData: [Date : (nowStep: Int, targetStep: Int)]
    
    // 선택 시
    let onTap: (Date) -> Void
    
    // 스크롤 시
    let scrollToPast: () -> Void
    let scrollToFuture: () -> Void
    
    // 상수
    @Environment(\.screenWidth) var screenWidth
    private let padding: CGFloat = 15
    
    // 스크롤 뷰 상태 변수
    @Binding var scrollPosition: Int?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                WeekView(
                    selectedDayOfTheWeek: selectedDate.dayOfTheWeek,
                    dates: pastWeek,
                    config: .healthCare(stepData: healthCareData),
                    onTap: onTap
                )
                .frame(width: screenWidth - padding * 2)
                .padding(.horizontal, padding)
                .id(-1)
                
                WeekView(
                    selectedDayOfTheWeek: selectedDate.dayOfTheWeek,
                    dates: presentWeek,
                    config: .healthCare(stepData: healthCareData),
                    onTap: onTap
                )
                .frame(width: screenWidth - padding * 2)
                .padding(.horizontal, padding)
                .id(0)
                
                if futureWeek.first?.getDayViewTime() != .future {
                    WeekView(
                        selectedDayOfTheWeek: selectedDate.dayOfTheWeek,
                        dates: futureWeek,
                        config: .healthCare(stepData: healthCareData),
                        onTap: onTap
                    )
                    .frame(width: screenWidth - padding * 2)
                    .padding(.horizontal, padding)
                    .id(1)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .onScrollPhaseChange { oldPhase, newPhase, context in
            if newPhase == .idle && oldPhase == .decelerating {
                let pageWidth = screenWidth - padding * 2
                let pageIndex = Int(
                    round(context.geometry.contentOffset.x / (pageWidth + padding * 2))
                )
                switch pageIndex {
                case 0:
                    scrollToPast()
                case 1:
                    break
                default:
                    scrollToFuture()
                }
            }
        }
    }
}
