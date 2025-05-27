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
    let onReviewTap: (ReviewItemId) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                characterImage
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        characterName
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
                        let info = ReviewItemId(
                            spotId: reviewState.spotID,
                            reviewId: reviewState.reviewID
                        )
                        print(info)
                        onReviewTap(info)
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
    }
    
    @ViewBuilder
    private var characterImage: some View {
        if reviewState.type == 0 {
            Image(jellyfishType?.getCharacterImage() ?? .imgJellyfish0)
                .resizable()
                .scaledToFit()
                .frame(width: 38, height: 38)
        } else {
            Image(dinoType?.getCharacterImage() ?? .imgDino0)
                .resizable()
                .scaledToFit()
                .frame(width: 38, height: 38)
        }
    }
    
    @ViewBuilder
    private var characterName: some View {
        if reviewState.type == 0 {
            Text(jellyfishType?.rawValue ?? "")
                .font(.H6)
                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
        } else {
            Text(dinoType?.rawValue ?? "")
                .font(.H6)
                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
        }
    }
    
    private var jellyfishType: JellyfishType? {
        try? JellyfishType.mapCharacterType(
            rank: reviewState.rank,
            characterClass: reviewState.characterClass
        )
    }
    
    private var dinoType: DinoType? {
        try? DinoType.mapCharacterType(
            rank: reviewState.rank,
            characterClass: reviewState.characterClass
        )
    }
}
