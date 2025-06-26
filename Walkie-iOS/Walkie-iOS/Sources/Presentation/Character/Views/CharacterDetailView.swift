//
//  CharacterDetailView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import SwiftUI
import WalkieCommon

import Kingfisher

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    @Environment(\.screenWidth) private var screenWidth
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(
            alignment: .bottom
        ) {
            switch viewModel.state {
            case .loaded(let state):
                ScrollView {
                    VStack(
                        spacing: 0
                    ) {
                        if let imgURL = URL(string: state.characterImage) {
                            KFImage.url(imgURL)
                                .loadDiskFileSynchronously(true)
                                .cacheMemoryOnly()
                                .frame(
                                    width: 180,
                                    height: 180
                                )
                                .scaledToFit()
                                .padding(.bottom, 12)
                        }
                        
                        Text(state.characterName)
                            .font(.H3)
                            .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                            .padding(.bottom, 8)
                        
                        Text(state.characterDescription)
                            .font(.B2)
                            .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        
                        HStack(
                            spacing: 8
                        ) {
                            Text(state.characterRank.rawValue)
                                .font(.H6)
                                .foregroundStyle(state.characterRank.fontColor)
                                .frame(width: 57, height: 36)
                                .background(WalkieCommonAsset.gray100.swiftUIColor)
                                .cornerRadius(99, corners: .allCorners)
                            
                            HighlightTextAttribute(
                                text: "\(state.characterCount)마리 보유",
                                textColor: WalkieCommonAsset.gray500.swiftUIColor,
                                font: .B2,
                                highlightText: "\(state.characterCount)",
                                highlightColor: WalkieCommonAsset.gray700.swiftUIColor,
                                highlightFont: .H6
                            )
                            .frame(height: 36)
                            .padding(.horizontal, 16)
                            .background(WalkieCommonAsset.gray100.swiftUIColor)
                            .cornerRadius(99, corners: .allCorners)
                        }
                        .padding(.bottom, 20)
                        
                        ForEach(state.obtainedState, id: \.id) { obtainedState in
                            HStack(spacing: 0) {
                                Circle()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(WalkieCommonAsset.blue300.swiftUIColor)
                                    .padding(.trailing, 8)
                                Text(obtainedState.obtainedPosition)
                                    .font(.B2)
                                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                                Spacer()
                                Text("\(obtainedState.obtainedDate) 부화")
                                    .font(.B2)
                                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 36)
                            .background(WalkieCommonAsset.gray100.swiftUIColor)
                            .cornerRadius(8, corners: .allCorners)
                            .padding(.bottom, 8)
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 114)
                }
                .scrollIndicators(.never)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 118)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(
                                    color: .white.opacity(0),
                                    location: 0.00),
                                Gradient.Stop(
                                    color: .white,
                                    location: 1.00)
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 0.26)
                        )
                    )
                CTAButton(
                    title: state.isWalking
                    ? "같이 걷는 중..."
                    : "이 캐릭터와 같이 걷기",
                    style: .primary,
                    size: .large,
                    isEnabled: !state.isWalking,
                    buttonAction: {
                        viewModel.action(.didSelectCharacterWalking)
                        dismiss()
                    }
                )
                .padding(.bottom, 38)
            default:
                CharacterDetailSkeletonView()
            }
        }
        .onAppear {
            viewModel.action(.willAppear)
        }
        .background(.white)
        .ignoresSafeArea()
    }
}
