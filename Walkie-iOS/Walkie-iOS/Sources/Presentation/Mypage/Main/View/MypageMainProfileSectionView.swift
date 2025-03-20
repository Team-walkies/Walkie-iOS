//
//  MypageMainProfileSectionView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

import WalkieCommon

struct MypageMainProfileSectionView: View {
    
    let mypageMainState: MypageMainViewModel.MypageMainState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text(mypageMainState.nickname)
                    .font(.H2)
                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                Text("님")
                    .font(.H2)
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                    .padding(.trailing, 8)
                Text(mypageMainState.userTier)
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.blue400.swiftUIColor)
                    .padding(.horizontal, 8)
                    .frame(height: 28)
                    .background(WalkieCommonAsset.blue50.swiftUIColor)
                    .cornerRadius(8)
                Spacer()
            }
            
            HighlightTextAttribute(
                text: "지금까지 \(mypageMainState.spotCount)개의 스팟을 탐험했어요",
                textColor: WalkieCommonAsset.gray500.swiftUIColor,
                font: .B1,
                highlightText: "\(mypageMainState.spotCount)",
                highlightColor: WalkieCommonAsset.blue400.swiftUIColor,
                highlightFont: .H5)
        }
    }
}
