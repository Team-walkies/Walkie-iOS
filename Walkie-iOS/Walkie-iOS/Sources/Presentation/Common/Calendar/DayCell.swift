//
//  DayCell.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 7/11/25.
//

import SwiftUI
import WalkieCommon

struct DayCell: View {
    
    let date: Date
    let isSelected: Bool
    let width: CGFloat
    let height: CGFloat
    let textColor: Color
    let backgroundColor: Color
    let hasDot: Bool
    
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
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(12, corners: .allCorners)
            ZStack {
                if hasDot {
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
