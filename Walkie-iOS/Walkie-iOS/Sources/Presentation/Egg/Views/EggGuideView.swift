//
//  EggGuideView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/19/25.
//

import SwiftUI
import WalkieCommon

struct EggGuideView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationBar(showBackButton: true)
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("알 얻을 확률")
                    .font(.H2)
                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
                Text("스팟 탐험 시 알을 얻을 확률이에요")
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                    .padding(.bottom, 12)
                ForEach(EggType.allCases, id: \.self) { eggType in
                    EggGuideItemView(eggType: eggType)
                }
                Text("캐릭터 얻을 확률")
                    .font(.H2)
                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                    .padding(.top, 40)
                    .padding(.bottom, 4)
                Text("얻기 어려운 알일수록 희귀한 캐릭터가 부화해요")
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                    .padding(.bottom, 20)
                ForEach(EggType.allCases, id: \.self) { eggType in
                    CharacterGuideItemView(eggType: eggType)
                    if eggType != EggType.allCases.last! {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(WalkieCommonAsset.gray50.swiftUIColor)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.never)
        .navigationBarBackButtonHidden()
    }
}

// 알 얻을 확률
private struct EggGuideItemView: View {
    let eggType: EggType
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(eggType.eggImage)
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.leading, 8)
                .padding(.trailing, 4)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(eggType.rawValue) 알")
                    .font(.B1)
                    .foregroundStyle(eggType.fontColor)
                Text(eggType.eggInformationText)
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
            }
            Spacer()
            Text("\(eggType.obtainRate)%")
                .font(.H3)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.trailing, 20)
        }
        .frame(height: 76)
        .background(WalkieCommonAsset.gray50.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
        .padding(.top, 8)
    }
}

// 캐릭터 얻을 확률
private struct CharacterGuideItemView: View {
    let eggType: EggType
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 4) {
                Image(eggType.eggImage)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(.leading, 8)
                    .padding(.trailing, 4)
                Text("\(eggType.rawValue) 알")
                    .font(.B1)
                    .foregroundStyle(eggType.fontColor)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                ForEach(EggType.allCases, id: \.rawValue) { (characterType: EggType) in
                    CharacterProbabilityView(eggType: eggType, characterType: characterType)
                }
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 40)
        .padding(.vertical, 22)
        .frame(height: 188)
    }
}

// 캐릭터 등급 별 확률
private struct CharacterProbabilityView: View {
    let eggType: EggType
    let characterType: EggType
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("\(characterType.rawValue) 캐릭터")
                .font(.B1)
                .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
            Text("\(eggType.characterObtainRate[characterType] ?? 0)%")
                .font(.H5)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
        }
    }
}
