//
//  DatePickerView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/10/25.
//

import SwiftUI
import WalkieCommon
import FirebaseAnalytics

struct DatePickerView: View {
    @StateObject var viewModel: DatePickerViewModel
    
    var body: some View {
        let state = viewModel.state
        GeometryReader { geometry in
            VStack {
                // 선택한 달 타이틀
                HStack(spacing: 4) {
                    let (year, month) = state.selectedMonth.getYearAndMonth()
                    Text(String(format: "%d년 %d월", year, month))
                        .font(.H4)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    Spacer()
                    Button(
                        action: {
                            viewModel.action(.didTapPreviousMonth)
                        }, label: {
                            Image(.icChevronLeft)
                                .renderingMode(.template)
                                .foregroundStyle(WalkieCommonAsset.blue300.swiftUIColor)
                        }
                    )
                    Button(
                        action: {
                            viewModel.action(.didTapNextMonth)
                        }, label: {
                            Image(.icChevronRight)
                                .renderingMode(.template)
                                .foregroundStyle(
                                    state.nextMonthAvailable
                                    ? WalkieCommonAsset.blue300.swiftUIColor
                                    : WalkieCommonAsset.gray300.swiftUIColor
                                )
                        }
                    )
                }
                .padding(.top, 40)
                .padding(.horizontal, 16)
                
                // 요일 행
                HStack(spacing: (geometry.size.width - 20 * 7) / 6) {
                    ForEach(DayOfTheWeek.allCases, id: \.self) { day in
                        Text(day.rawValue)
                            .font(.B2)
                            .foregroundStyle(WalkieCommonAsset.gray400.swiftUIColor)
                    }
                }
                .padding(.horizontal, 28)
                
                // 달력
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(0..<state.offset, id: \.self) { _ in
                        Text("")
                    }
                    ForEach(1..<(state.daysInMonth ?? 0) + 1, id: \.self) { day in
                        let components = DateComponents(
                            year: state.selectedMonth.getYearAndMonth().year,
                            month: state.selectedMonth.getYearAndMonth().month,
                            day: day
                        )
                        if let newDate = Calendar.current.date(from: components) {
                            Button(
                                action: {
                                    viewModel.action(.selectedDate(date: newDate))
                                }
                                , label: {
                                    Text("\(day)")
                                        .font(.B2)
                                        .foregroundStyle(
                                            newDate.getDayViewTime() != .future
                                            ? Calendar.current.isDate(
                                                state.selectedDate,
                                                equalTo: state.selectedMonth, toGranularity: .month
                                            ) &&
                                            day == Calendar.current.component(
                                                .day,
                                                from: state.selectedDate
                                            )
                                            ? .white
                                            : WalkieCommonAsset.gray700.swiftUIColor
                                            : WalkieCommonAsset.gray300.swiftUIColor
                                        )
                                        .frame(width: 32, height: 32)
                                        .background(
                                            Calendar.current.isDate(
                                                state.selectedDate,
                                                equalTo: state.selectedMonth, toGranularity: .month
                                            ) &&
                                            day == Calendar.current.component(
                                                .day,
                                                from: state.selectedDate
                                            )
                                            ? WalkieCommonAsset.blue300.swiftUIColor : .white
                                        )
                                        .clipShape(Circle())
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                CTAButton(
                    title: "이동하기",
                    style: .primary,
                    size: .large,
                    isEnabled: true,
                    buttonAction: {
                        viewModel.action(.didTapSelectButton)
                        Analytics.logEvent(StringLiterals.WalkieLog.spotCalendarMove, parameters: nil)
                    }
                )
                .padding(.bottom, 38)
            }
            .onAppear {
                viewModel.action(.willAppear)
            }
            .background(.white)
        }
    }
}
