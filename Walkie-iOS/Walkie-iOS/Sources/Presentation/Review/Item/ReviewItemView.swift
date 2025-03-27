//
//  ReviewItemView.swift
//  Walkie-iOS
//
//  Created by ahra on 3/27/25.
//

import SwiftUI

import WalkieCommon

struct ReviewItemView: View {
    
    @State var reviewState: Review
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                let characterImg = CharacterType.getCharacterImage(
                    type: reviewState.type + 1,
                    characterClass: reviewState.characterClass)
                Image(characterImg ?? .emptyJellyfish)
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
                    
                    if let startTime = formatTimeString(reviewState.startTime),
                        let endTime = formatTimeString(reviewState.endTime) {
                        Text("\(startTime) ~ \(endTime)")
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    print(reviewState.reviewID)
                }, label: {
                    Image(.icMore)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                })
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
                        
                        let formattedDistance = String(format: "%.1f", reviewState.distance)
                        Text("\(formattedDistance)km")
                            .font(.H5)
                            .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    
                    VStack {
                        Text("걸음수")
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        Text("\(reviewState.step)")
                            .font(.H5)
                            .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                    }
                    
                    VStack {
                        Text("이동 시간")
                            .font(.C1)
                            .foregroundColor(WalkieCommonAsset.gray500.swiftUIColor)
                        
                        if let minutes = timeDifferenceInMinutes(
                            startTime: reviewState.startTime,
                            endTime: reviewState.endTime) {
                            Text("\(minutes)m")
                                .font(.H5)
                                .foregroundColor(WalkieCommonAsset.gray700.swiftUIColor)
                        }
                    }
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
                RankStarView(rank: reviewState.rank)
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

extension ReviewItemView {
    
    func timeDifferenceInMinutes(startTime: String, endTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let start = dateFormatter.date(from: startTime),
            let end = dateFormatter.date(from: endTime) {
            let difference = end.timeIntervalSince(start)
            return Int(difference / 60)
        }
        return nil
    }
    
    func formatTimeString(_ timeString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        
        guard let date = inputFormatter.date(from: timeString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "a h:mm"
        
        return outputFormatter.string(from: date)
    }
}
