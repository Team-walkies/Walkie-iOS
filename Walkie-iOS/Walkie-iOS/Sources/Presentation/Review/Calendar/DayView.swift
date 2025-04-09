//
//  DayView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 4/7/25.
//

import SwiftUI
import WalkieCommon

struct DayView: View {
    var state: DayViewState
    let date: Date
    
    private var textColor: Color {
        switch state.time {
        case .past:
            return state.isSelected ? .white : WalkieCommonAsset.gray700.swiftUIColor
        case .today:
            return state.isSelected ? .white : WalkieCommonAsset.blue300.swiftUIColor
        case .future:
            return WalkieCommonAsset.gray300.swiftUIColor
        }
    }
    
    private var backgroundColor: Color {
        if state.isSelected {
            switch state.time {
            case .past: return WalkieCommonAsset.gray600.swiftUIColor
            case .today: return WalkieCommonAsset.blue300.swiftUIColor
            case .future: return .white
            }
        }
        return .white
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text(date.dayOfTheWeek.rawValue)
                    .font(.B2)
                    .foregroundStyle(textColor)
                    .padding(.top, 6)
                
                Text("\(date.dayOfMonth)")
                    .font(.H5)
                    .foregroundStyle(textColor)
                    .padding(.bottom, 3)
            }
            .frame(width: 45, height: 58)
            .background(backgroundColor)
            .cornerRadius(12)
            ZStack {
                if state.hasSpot {
                    Circle()
                        .strokeBorder(.white, lineWidth: 1)
                        .background(Circle().fill(WalkieCommonAsset.blue300.swiftUIColor))
                        .frame(width: 8, height: 8)
                        .offset(y: -3)
                } else {
                    Spacer().frame(width: 8, height: 8)
                }
            }
        }
    }
}
