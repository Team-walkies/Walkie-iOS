//
//  HomeCharacterView.swift
//  Walkie-iOS
//
//  Created by ahra on 2/21/25.
//

import SwiftUI

import WalkieCommon
import FirebaseAnalytics

struct HomeCharacterView: View {
    
    let homeState: HomeViewModel.HomeCharacterState
    let width: CGFloat
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(homeState.characterName)
                    .font(.H6)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                
                Text("와 함께 걷는 중..")
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
            }
            .padding(.leading, 16)
            Spacer()
        }
        .frame(
            width: width,
            height: 52
        )
        .background(WalkieCommonAsset.gray100.swiftUIColor)
        .mask(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            Analytics.logEvent(StringLiterals.WalkieLog.mainTogether, parameters: nil)
        }
    }
}
