//
//  CharacterDetailView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/29/25.
//

import SwiftUI
import WalkieCommon

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loaded(let obtainedState, let detailState):
                ZStack(alignment: .bottom) {
                    ScrollView {
                        VStack(spacing: 0) {
                            Image(detailState.characterImage)
                                .resizable()
                                .frame(width: 180, height: 180)
                                .padding(.bottom, 12)
                            Text(detailState.characterName)
                                .font(.H3)
                                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                                .padding(.bottom, 8)
                            Text(detailState.characterDescription)
                                .font(.B2)
                                .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            HStack(spacing: 8) {
                                Text(detailState.characterRank.rawValue)
                                    .font(.H6)
                                    .foregroundStyle(detailState.characterRank.fontColor)
                                    .frame(width: 57, height: 36)
                                    .background(WalkieCommonAsset.gray100.swiftUIColor)
                                    .cornerRadius(99)
                                HighlightTextAttribute(
                                    text: "\(detailState.characterCount)마리 보유",
                                    textColor: WalkieCommonAsset.gray500.swiftUIColor,
                                    font: .B2,
                                    highlightText: "\(detailState.characterCount)",
                                    highlightColor: WalkieCommonAsset.gray700.swiftUIColor,
                                    highlightFont: .H6
                                )
                                .frame(height: 36)
                                .padding(.horizontal, 16)
                                .background(WalkieCommonAsset.gray100.swiftUIColor)
                                .cornerRadius(99)
                            }.padding(.bottom, 20)
                            ForEach(obtainedState, id: \.id) { obtainedState in
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
                                .cornerRadius(8)
                                .padding(.bottom, 8)
                                .padding(.horizontal, 16)
                            }
                        }.padding(.bottom, 114)
                    }.scrollIndicators(.never)
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
                        title: detailState.isWalking
                        ? "같이 걷는 중..."
                        : "이 캐릭터와 같이 걷기",
                        style: .primary,
                        size: .large,
                        isEnabled: !detailState.isWalking,
                        buttonAction: {
                            viewModel.action(.didSelectCharacterWalking)
                        }
                    ).padding(.bottom, 38)
                }
            case .error(let error):
                Text(error.description)
            default:
                ProgressView()
            }
        }.onAppear {
            viewModel.action(.willAppear)
        }
        .background(.white)
        .ignoresSafeArea()
    }
}
