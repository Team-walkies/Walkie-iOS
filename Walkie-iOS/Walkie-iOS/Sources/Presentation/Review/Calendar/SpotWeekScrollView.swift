//
//  SpotWeekScrollView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/11/25.
//

import SwiftUI

struct SpotWeekScrollView: View {
    // 날짜 데이터
    let pastWeek: [Date]
    let presentWeek: [Date]
    let futureWeek: [Date]
    
    // 스팟 관련
    let selectedDate: Date
    let hasSpotOn: [Date]
    
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
                    config: .spotReview(hasSpotOn: hasSpotOn),
                    onTap: onTap
                )
                .frame(width: screenWidth - padding * 2)
                .padding(.horizontal, padding)
                .id(-1)
                
                WeekView(
                    selectedDayOfTheWeek: selectedDate.dayOfTheWeek,
                    dates: presentWeek,
                    config: .spotReview(hasSpotOn: hasSpotOn),
                    onTap: onTap
                )
                .frame(width: screenWidth - padding * 2)
                .padding(.horizontal, padding)
                .id(0)
                
                if futureWeek.first?.getDayViewTime() != .future {
                    WeekView(
                        selectedDayOfTheWeek: selectedDate.dayOfTheWeek,
                        dates: futureWeek,
                        config: .spotReview(hasSpotOn: hasSpotOn),
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
