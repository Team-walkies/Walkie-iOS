//
//  CalendarHeaderView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/16/25.
//

import SwiftUI
import WalkieCommon

struct CalendarHeaderView: View {
    let selectedDate: Date
    let onTapToday: () -> Void
    let onTapCalendar: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            let (year, month) = selectedDate.getYearAndMonth()
            Text(String(format: "%d년 %d월", year, month))
                .font(.H2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.leading, 1)
            
            Button(action: {
                onTapCalendar()
            }, label: {
                Image(.icCalendar)
            })
            
            Spacer()
            
            Button(action: {
                onTapToday()
            }, label: {
                Text("오늘")
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                    .font(.C1)
                    .frame(width: 45, height: 32)
                    .background(WalkieCommonAsset.gray100.swiftUIColor)
                    .cornerRadius(16, corners: .allCorners)
                    .padding(.trailing, 1)
            })
        }
    }
}
