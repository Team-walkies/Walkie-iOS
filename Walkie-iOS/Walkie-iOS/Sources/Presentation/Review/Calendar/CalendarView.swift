//
//  CalendarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/10/25.
//

import SwiftUI
import WalkieCommon

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @ObservedObject private var datePickerViewModel = DatePickerViewModel(selectedDate: Date())
    
    @State private var showPicker: Bool = false
    @State private var pickerDetent = PresentationDetent.medium
    @State private var currentWeekOffset: CGFloat = 0
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            // Header
            HStack(alignment: .center, spacing: 8) {
                if case .selectedWeek(let firstDay, _) = viewModel.state {
                    let (year, month) = firstDay.getYearAndMonth()
                    Text(String(format: "%d년 %d월", year, month))
                        .font(.H2)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                        .padding(.leading, 1)
                }
                Button(action: {
                    showPicker = true
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
                    .cornerRadius(16)
                    .padding(.trailing, 1)
                })
            }
            
            if case .selectedWeek(let firstDay, let days) = viewModel.state {
                GeometryReader { geometry in
                    let weekWidth = geometry.size.width
                    let spacingBetweenWeeks: CGFloat = 30
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacingBetweenWeeks) {
                            let previousWeekDays = viewModel.generateWeekDays(
                                from: Calendar.current.date(
                                    byAdding: .day,
                                    value: -7,
                                    to: firstDay
                                )!
                            )
                            HStack(spacing: 0) {
                                ForEach(previousWeekDays) { dayState in
                                    DayView(
                                        state: dayState,
                                        date: dayState.date
                                    )
                                    .frame(width: weekWidth / 7)
                                    .disabled(dayState.time == .future)
                                    .onTapGesture {
                                        if dayState.time != .future {
                                            viewModel.action(.willSelectDate(dayState.date))
                                        }
                                    }
                                }
                            }
                            .frame(width: weekWidth)
                            
                            HStack(spacing: 0) {
                                ForEach(days) { dayState in
                                    DayView(
                                        state: dayState,
                                        date: dayState.date
                                    )
                                    .frame(width: weekWidth / 7)
                                    .disabled(dayState.time == .future)
                                    .onTapGesture {
                                        if dayState.time != .future {
                                            viewModel.action(.willSelectDate(dayState.date))
                                        }
                                    }
                                }
                            }
                            .frame(width: weekWidth)
                            
                            let nextWeekDays = viewModel.generateWeekDays(
                                from: Calendar.current.date(
                                    byAdding: .day,
                                    value: 7,
                                    to: firstDay
                                )!
                            )
                            HStack(spacing: 0) {
                                ForEach(nextWeekDays) { dayState in
                                    DayView(
                                        state: dayState,
                                        date: dayState.date
                                    )
                                    .frame(width: weekWidth / 7)
                                    .disabled(dayState.time == .future)
                                    .onTapGesture {
                                        if dayState.time != .future {
                                            viewModel.action(.willSelectDate(dayState.date))
                                        }
                                    }
                                }
                            }
                            .frame(width: weekWidth)
                        }
                        .frame(width: weekWidth * 3 + spacingBetweenWeeks * 2)
                    }
                    .content.offset(x: currentWeekOffset - weekWidth - spacingBetweenWeeks)
                    .gesture(
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
                                        viewModel.action(.willScrollToNextWeek(firstDay))
                                        currentWeekOffset = 0
                                    } else if adjustedTranslation > threshold {
                                        viewModel.action(.willScrollToPreviousWeek(firstDay))
                                        currentWeekOffset = 0
                                    } else {
                                        currentWeekOffset = 0
                                    }
                                }
                            }
                    )
                    .scrollTargetBehavior(.viewAligned)
                    .onChange(of: viewModel.state) {
                        withAnimation {
                            currentWeekOffset = 0
                        }
                    }
                }
                .frame(height: 70)
            }
        }
        .frame(height: 128)
        .padding(.horizontal, 15)
        .bottomSheet(isPresented: $showPicker, height: 400) {
            VStack {
                DatePickerView(viewModel: datePickerViewModel)
                Spacer()
            }.background(.white)
        }
    }
}

#Preview {
    CalendarView()
}
