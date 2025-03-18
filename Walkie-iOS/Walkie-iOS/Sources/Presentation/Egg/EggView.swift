//
//  EggView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/18/25.
//

import SwiftUI

struct EggView: View {
    
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var ex1: Bool = true
    @State var ex2: Double = 3000
    
    var body: some View {
        NavigationBar(
            rightButtonTitle: "안내",
            showBackButton: true,
            showRightButton: true,
            rightButtonAction:  {
                // 알 얻을 확률 안내로 이동
            })
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 8) {
                    Text("보유한 알")
                        .font(.H2)
                        .foregroundStyle(.gray700)
                    Text("7")
                        .font(.H2)
                        .foregroundStyle(.gray500)
                    Spacer()
                }.padding(.bottom, 4)
                Text("같이 걷고 싶은 알을 선택해 주세요")
                    .font(.B2)
                    .foregroundStyle(.gray500)
                    .padding(.bottom, 20)
                LazyVGrid(columns: gridColumns, alignment: .center, spacing: 11) {
                    ForEach(0..<20, id: \.self) { _ in
                        EggItemView(eggType: .rare, isWalking: $ex1, currentCount: $ex2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
    }
}

private struct EggItemView: View {
    
    let itemWidth = (UIScreen.main.bounds.width - 16*2 - 11)/2
    
    let eggType: EggLiterals
    @Binding var isWalking: Bool
    @Binding var currentCount: Double
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(eggType.eggImage)
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Text(eggType.rawValue)
                .font(.C1)
                .foregroundStyle(eggType.fontColor)
                .frame(width: 37, height: 24)
                .background(.white)
                .cornerRadius(99)
                .padding(.bottom, 8)
            ProgressBarView(
                isSmall: true,
                current: currentCount,
                total: eggType.walkCount)
            .padding(.bottom, 8)
            HighlightTextAttribute(
                text: String(format: "%.0f / %.0f", locale: Locale.current, currentCount, eggType.walkCount),
                textColor: .gray500,
                font: .B1,
                highlightText: String(format: "%.0f /", locale: Locale.current, currentCount),
                highlightColor: .gray700,
                highlightFont: .H5)
            .padding(.bottom, 16)
        }
        .frame(width: itemWidth, height: 188)
        .background(.gray100)
        .cornerRadius(20)
        .overlay {
            if isWalking {
                Image(.icFoot)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.blue300)
                    .frame(width: 18, height: 18)
                    .alignTo(.topTrailing)
                    .padding(12)
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.blue300, lineWidth: 2)
            }
        }
    }
}

#Preview {
    EggView()
}
