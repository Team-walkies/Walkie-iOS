//
//  EggDetailView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/19/25.
//

import SwiftUI
import WalkieCommon

struct EggDetailView: View {
    
    @Environment(\.screenWidth) var screenWidth
    @ObservedObject var eggViewModel: EggViewModel
    @ObservedObject var viewModel: EggDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            switch viewModel.state {
            case .loaded(let eggState):
                Image(eggState.eggType.eggImage)
                    .resizable()
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 4)
                    .padding(.top, 48)
                Text(eggState.eggType.rawValue)
                    .font(.H6)
                    .foregroundStyle(eggState.eggType.fontColor)
                    .frame(width: 57, height: 36)
                    .background(WalkieCommonAsset.gray100.swiftUIColor)
                    .cornerRadius(99, corners: .allCorners)
                    .padding(.bottom, 4)
                HighlightTextAttribute(
                    text: String(
                        format: "%d / %d 걸음",
                        locale: Locale.init(identifier: "ko"),
                        eggState.nowStep,
                        eggState.needStep),
                    textColor: WalkieCommonAsset.gray500.swiftUIColor,
                    font: .B1,
                    highlightText: String(
                        format: "%d /",
                        locale: Locale.init(identifier: "ko"),
                        eggState.nowStep),
                    highlightColor: WalkieCommonAsset.gray700.swiftUIColor,
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
                            .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                        Text(eggState.obtainedDate)
                            .font(.H6)
                            .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    .frame(width: (screenWidth-41)/2, height: 68)
                    .background(WalkieCommonAsset.gray50.swiftUIColor)
                    .cornerRadius(12, corners: .allCorners)
                    VStack(alignment: .center, spacing: 4) {
                        Text("획득 장소")
                            .font(.B2)
                            .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                        Text(eggState.obtainedPosition)
                            .font(.H6)
                            .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    .frame(width: (screenWidth-41)/2, height: 68)
                    .background(WalkieCommonAsset.gray50.swiftUIColor)
                    .cornerRadius(12, corners: .allCorners)
                }.padding(.bottom, 20)
                CTAButton(
                    title: eggState.isWalking ? "같이 걷는 중..." : "이 알과 같이 걷기",
                    style: .primary,
                    size: .large,
                    isEnabled: !eggState.isWalking,
                    buttonAction: {
                        viewModel.action(.didSelectEggWalking)
                    }
                )
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
