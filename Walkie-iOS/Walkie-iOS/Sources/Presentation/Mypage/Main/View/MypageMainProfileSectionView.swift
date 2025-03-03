//
//  MypageMainProfileSectionView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/1/25.
//

import SwiftUI

struct MypageMainProfileSectionView: View {
    
    let mypageMainState: MypageMainViewModel.MypageMainState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text(mypageMainState.nickname)
                    .font(.H2)
                    .foregroundStyle(.gray700)
                Text("님")
                    .font(.H2)
                    .foregroundStyle(.gray500)
                    .padding(.trailing, 8)
                Text(mypageMainState.userTier)
                    .font(.B2)
                    .foregroundStyle(.blue400)
                    .padding(.horizontal, 8)
                    .frame(height: 28)
                    .background(.blue50)
                    .cornerRadius(8)
                Spacer()
            }
            
            HighlightTextAttribute(
                text: "지금까지 \(mypageMainState.spotCount)개의 스팟을 탐험했어요",
                textColor: .gray500,
                font: .B1,
                highlightText: "\(mypageMainState.spotCount)",
                highlightColor: .blue400,
                highlightFont: .H5)
        }
    }
}
