//
//  MypageMainFeedbackButtonView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

import WalkieCommon

struct MypageMainFeedbackButtonView: View {
    var body: some View {
        NavigationLink(
            destination:
                MypageWebView(url: MypageNotionWebViewURL.questions.url)
                .navigationBarBackButtonHidden()
        ) {
            HStack(spacing: 0) {
                Image(.icMyFeedback)
                    .frame(width: 36, height: 36)
                    .padding(.trailing, 8)
                VStack(alignment: .leading, spacing: 4) {
                    Text("앱에 대한 의견을 남겨주세요!")
                        .font(.B2)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    Text("더 나은 서비스를 위해 노력할게요")
                        .font(.C1)
                        .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                }
                Spacer()
                Image(.icChevronRight)
                    .frame(width: 28, height: 28)
                    .foregroundColor(WalkieCommonAsset.gray300.swiftUIColor)
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 72)
        .background(WalkieCommonAsset.gray100.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
    }
}
