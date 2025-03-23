//
//  EggDetailView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/19/25.
//

import SwiftUI

struct EggDetailView: View {
    
    @Environment(\.screenWidth) var screenWidth
    @ObservedObject var viewModel: EggDetailViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            switch viewModel.state {
            case .loaded(let detail, let eggState):
                Image(eggState.eggType.eggImage)
                    .resizable()
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 4)
                    .padding(.top, 48)
                Text(eggState.eggType.rawValue)
                    .font(.H6)
                    .foregroundStyle(eggState.eggType.fontColor)
                    .frame(width: 57, height: 36)
                    .background(.gray100)
                    .cornerRadius(99)
                    .padding(.bottom, 4)
                HighlightTextAttribute(
                    text: String(
                        format: "%d / %d 걸음",
                        locale: Locale.init(identifier: "ko"),
                        eggState.nowStep,
                        eggState.needStep),
                    textColor: .gray500,
                    font: .B1,
                    highlightText: String(
                        format: "%d /",
                        locale: Locale.init(identifier: "ko"),
                        eggState.nowStep),
                    highlightColor: .gray700,
                    highlightFont: .H5)
                .padding(.bottom, 12)
                ProgressBarView(
                    isSmall: false,
                    current: eggState.nowStep,
                    total: eggState.needStep)
                .padding(.bottom, 20)
                HStack(alignment: .center, spacing: 9) {
                    VStack(alignment: .center, spacing: 4) {
                        Text("획득 날짜")
                            .font(.B2)
                            .foregroundStyle(.gray500)
                        Text(detail.obtainedDate ?? "오류")
                            .font(.H6)
                            .foregroundStyle(.gray700)
                    }
                    .frame(width: (screenWidth-41)/2, height: 68)
                    .background(.gray50)
                    .cornerRadius(12)
                    VStack(alignment: .center, spacing: 4) {
                        Text("획득 장소")
                            .font(.B2)
                            .foregroundStyle(.gray500)
                        Text(detail.obtainedPosition ?? "오류")
                            .font(.H6)
                            .foregroundStyle(.gray700)
                    }
                    .frame(width: (screenWidth-41)/2, height: 68)
                    .background(.gray50)
                    .cornerRadius(12)
                }.padding(.bottom, 20)
                CTAButton(
                    title: eggState.isWalking ? "같이 걷는 중..." : "이 알과 같이 걷기",
                    style: .primary,
                    size: .large,
                    isEnabled: !eggState.isWalking,
                    buttonAction: {
                        viewModel.action(.didSelectEggWalking)
                    })
                Spacer()
            case .error(let error):
                Text(error.description)
            default:
                ProgressView()
            }
        }
        .background(.white)
        .onAppear {
            viewModel.action(.willAppear)
        }
    }
}
