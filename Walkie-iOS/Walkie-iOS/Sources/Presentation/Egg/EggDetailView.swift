//
//  EggDetailView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/19/25.
//

import SwiftUI

struct EggDetailView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    let eggType: EggLiterals
    let currentCount: Int
    let isWalking: Bool
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(eggType.eggImage)
                .resizable()
                .frame(width: 180, height: 180)
                .padding(.bottom, 4)
                .padding(.top, 48)
            Text(eggType.rawValue)
                .font(.H6)
                .foregroundStyle(eggType.fontColor)
                .frame(width: 57, height: 36)
                .background(.gray100)
                .cornerRadius(99)
                .padding(.bottom, 4)
            HighlightTextAttribute(
                text: String(
                    format: "%.0f / %.0f 걸음",
                    locale: Locale.init(identifier: "ko"),
                    currentCount,
                    eggType.walkCount),
                textColor: .gray500,
                font: .B1,
                highlightText: String(
                    format: "%.0f /",
                    locale: Locale.init(identifier: "ko"),
                    currentCount),
                highlightColor: .gray700,
                highlightFont: .H5)
            .padding(.bottom, 12)
            ProgressBarView(
                isSmall: false,
                current: currentCount,
                total: eggType.walkCount)
            .padding(.bottom, 20)
            HStack(alignment: .center, spacing: 9) {
                VStack(alignment: .center, spacing: 4) {
                    Text("획득 날짜")
                        .font(.B2)
                        .foregroundStyle(.gray500)
                    Text("2024년 1월 12일")
                        .font(.H6)
                        .foregroundStyle(.gray700)
                }
                .frame(width: (screenWidth-41)/2, height: 68)
                .background(.gray50)
                .cornerRadius(12)
                VStack(alignment: .center, spacing: 4) {
                    Text("획득 날짜")
                        .font(.B2)
                        .foregroundStyle(.gray500)
                    Text("2024년 1월 12일")
                        .font(.H6)
                        .foregroundStyle(.gray700)
                }
                .frame(width: (screenWidth-41)/2, height: 68)
                .background(.gray50)
                .cornerRadius(12)
            }.padding(.bottom, 20)
            CTAButton(
                title: isWalking ? "같이 걷는 중..." : "이 알과 같이 걷기",
                style: .primary,
                size: .large,
                isEnabled: !isWalking,
                buttonAction: {
                    // 이 알과 같이 걷기
                })
            Spacer()
        }
        .background(.white)
    }
}
