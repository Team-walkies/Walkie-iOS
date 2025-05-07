//
//  ReviewItemView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import SwiftUI

import WalkieCommon

struct ReviewItemView: View {
    
    @State var reviewState: ReviewViewModel.ReviewState
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                let characterImg = CharacterType.getCharacterImage(
                    type: reviewState.type + 1,
                    characterClass: reviewState.characterClass)
                Image(characterImg ?? .imgDino0)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        let characterName = CharacterType.getCharacterName(
                            type: reviewState.type + 1,
                            characterClass: reviewState.characterClass)
                        Text("\(characterName ?? "")")
                            .font(.H6)
                            .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                        Text("와 걸었어요")
                            .font(.B2)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                    }
                    Text(reviewState.walkTime)
                        .font(.C1)
                        .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                }
                Spacer()
                Button(
                    action: {
                        print(reviewState.reviewID)
                    }, label: {
                        Image(.icMore)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                )
            }
            
            VStack(spacing: 12) {
                HStack(alignment: .center) {
                    Image(.icMapPark)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(reviewState.spotName)
                        .font(.H6)
                        .foregroundColor(WalkieCommonAsset.blue400.swiftUIColor)
                }
                Rectangle()
                    .fill(WalkieCommonAsset.gray200.swiftUIColor)
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                HStack {
                    VStack {
                        Text("이동 거리")
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        Text(reviewState.distance)
                            .font(.H5)
                            .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Text("걸음수")
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        Text("\(reviewState.step)")
                            .font(.H5)
                            .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Text("이동 시간")
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        Text(reviewState.duration)
                            .font(.H5)
                            .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 12)
            .cornerRadius(12, corners: .allCorners)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(WalkieCommonAsset.gray200.swiftUIColor, lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 8) {
                RankStarView(rank: reviewState.rating)
                    .frame(maxWidth: .infinity)
                Text(reviewState.review)
                    .font(.B2)
                    .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    .multilineTextAlignment(.leading)
            }
            .padding(.all, 16)
            .frame(maxWidth: .infinity)
            .background(WalkieCommonAsset.gray100.swiftUIColor)
            .cornerRadius(12, corners: .allCorners)
        }
        .padding(.horizontal, 16)
    }
}
