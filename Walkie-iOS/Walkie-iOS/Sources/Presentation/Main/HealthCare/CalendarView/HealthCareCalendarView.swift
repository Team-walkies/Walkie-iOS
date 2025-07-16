//
//  HealthCareCalendarView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/15/25.
//

import SwiftUI
import WalkieCommon

struct HealthCareCalendarView: View {
    
    @StateObject var viewModel: HealthCareCalendarViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CalendarHeaderView(
                selectedDate: viewModel.state.selectedDate,
                onTapToday: {
                    viewModel.action(.selectDate(Date()))
                },
                onTapCalendar: {
                    viewModel.action(.willShowDatePicker)
                }
            )
            .padding(.horizontal, 16)
            .frame(height: 34)
            .padding(.bottom, 12)
            HealthCareWeekScrollView(
                pastWeek: viewModel.state.pastWeek,
                presentWeek: viewModel.state.presentWeek,
                futureWeek: viewModel.state.futureWeek,
                selectedDate: viewModel.state.selectedDate,
                healthCareData: viewModel.state.healthCareData,
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
            .frame(height: 94)
            Spacer(minLength: 12)
        }
        .background(.white)
        .frame(height: 152)
    }
}
