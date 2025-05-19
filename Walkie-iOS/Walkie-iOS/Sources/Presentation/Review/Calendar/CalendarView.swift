//
//  CalendarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/10/25.
//

import SwiftUI
import WalkieCommon

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State private var currentWeekOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            headerView
                .padding(.bottom, 12)
                .padding(.horizontal, 15)
            weekScrollView
                .padding(.horizontal, 15)
            Spacer(minLength: 0)
            Rectangle()
                .frame(height: 4)
                .frame(maxWidth: .infinity)
                .foregroundStyle(WalkieCommonAsset.gray50.swiftUIColor)
        }
        .frame(height: 128)
    }
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: 8) {
            let (year, month) = viewModel.state.selectedYearAndMonth
            Text(String(format: "%d년 %d월", year, month))
                .font(.H2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.leading, 1)
            
            Button(action: {
                viewModel.showPicker = true
            }, label: {
                Image(.icCalendar)
            })
            
            Spacer()
            
            Button(action: {
                viewModel.action(.didTapTodayButton)
            }, label: {
                ZStack {
                    Text("오늘")
                        .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                        .font(.C1)
                }
                .frame(width: 45, height: 32)
                .background(WalkieCommonAsset.gray100.swiftUIColor)
                .cornerRadius(16, corners: .allCorners)
                .padding(.trailing, 1)
            })
        }
    }
    
    private var weekScrollView: some View {
        GeometryReader { geometry in
            let weekWidth = geometry.size.width
            let spacingBetweenWeeks: CGFloat = 30
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacingBetweenWeeks) {
                    weekView(states: viewModel.weekState.previousWeek, width: weekWidth)
                    weekView(states: viewModel.weekState.selectedWeek, width: weekWidth)
                    weekView(states: viewModel.weekState.nextWeek, width: weekWidth)
                }
                .frame(width: weekWidth * 3 + spacingBetweenWeeks * 2)
            }
            .content.offset(x: currentWeekOffset - weekWidth - spacingBetweenWeeks)
            .gesture(dragGesture(weekWidth: weekWidth))
            .scrollTargetBehavior(.viewAligned)
            .onChange(of: viewModel.state) {
                withAnimation {
                    currentWeekOffset = 0
                }
            }
            .onChange(of: viewModel.weekState) {
                withAnimation {
                    currentWeekOffset = 0
                }
            }
        }
        .frame(height: 70)
    }
    
    private func weekView(states: [DayViewState], width: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(states) { dayState in
                DayView(state: dayState, date: dayState.date)
                    .frame(width: width / 7)
                    .disabled(dayState.time == .future)
                    .onTapGesture {
                        if dayState.time != .future {
                            viewModel.action(.willSelectDate(dayState.date))
                        }
                    }
            }
        }
        .frame(width: width)
    }
    
    private func dragGesture(weekWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                currentWeekOffset = value.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = weekWidth / 2
                let sensitivity: CGFloat = 1.3
                let adjustedTranslation = value.translation.width / sensitivity
                withAnimation(.easeInOut(duration: 0.1)) {
                    if adjustedTranslation < -threshold {
                        if let firstDay = viewModel.weekState.selectedWeek.first?.date {
                            viewModel.action(.willScrollToNextWeek(firstDay))
                        }
                        currentWeekOffset = 0
                    } else if adjustedTranslation > threshold {
                        if let firstDay = viewModel.weekState.selectedWeek.first?.date {
                            viewModel.action(.willScrollToPreviousWeek(firstDay))
                        }
                        currentWeekOffset = 0
                    } else {
                        currentWeekOffset = 0
                    }
                }
            }
    }
}
