//
//  SpotCalendarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/11/25.
//

import SwiftUI
import WalkieCommon

struct SpotCalendarView: View {
    
    @StateObject var viewModel: SpotCalendarViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CalendarHeaderView(
                selectedDate: viewModel.state.selectedDate,
                onTapToday: {
                    viewModel.action(.selectDate(Date()))
                },
                onTapCalendar: {
                    appCoordinator.buildBottomSheet(
                        height: 436,
                        content: {
                            DatePickerView(
                                viewModel: DatePickerViewModel(
                                    delegate: viewModel,
                                    selectedDate: viewModel.state.selectedDate
                                )
                            )
                        }
                    )
                }
            )
            .frame(height: 34)
            .padding(.bottom, 12)
            .padding(.horizontal, 15)
            SpotWeekScrollView(
                pastWeek: viewModel.state.pastWeek,
                presentWeek: viewModel.state.presentWeek,
                futureWeek: viewModel.state.futureWeek,
                selectedDate: viewModel.state.selectedDate,
                hasSpotOn: viewModel.state.hasSpotOn,
                onTap: { date in
                    viewModel.action(.selectDate(date))
                },
                scrollToPast: {
                    viewModel.action(.scrollToPast)
                },
                scrollToFuture: {
                    viewModel.action(.scrollToFuture)
                },
                scrollPosition: $viewModel.state.scrollPosition
            )
            Spacer(minLength: 0)
            Rectangle()
                .frame(height: 4)
                .frame(maxWidth: .infinity)
                .foregroundStyle(WalkieCommonAsset.gray50.swiftUIColor)
        }
        .frame(height: 128)
    }
}
