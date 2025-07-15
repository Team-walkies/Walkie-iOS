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
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            headerView
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
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: 8) {
            let (year, month) = viewModel.state.selectedDate.getYearAndMonth()
            Text(String(format: "%d년 %d월", year, month))
                .font(.H2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.leading, 1)
            
            Button(action: {
                viewModel.action(.willShowDatePicker)
            }, label: {
                Image(.icCalendar)
            })
            
            Spacer()
            
            Button(action: {
                viewModel.action(.selectDate(Date()))
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
}

#Preview {
    SpotCalendarView(viewModel: SpotCalendarViewModel(calendarUseCase: DefaultCalendarUseCase()))
}
