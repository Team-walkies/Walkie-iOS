//
//  CharacterView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/28/25.
//

import SwiftUI
import WalkieCommon

struct CharacterView: View {
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ObservedObject var viewModel: CharacterViewModel
    @State var isPresentingBottomSheet: Bool = false
    
    var body: some View {
        NavigationBar(showBackButton: true)
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                switch self.viewModel.state {
                case .loaded(let state):
                    Text("부화한 캐릭터")
                        .font(.H2)
                        .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    HStack(alignment: .center, spacing: 8) {
                        Text(CharacterType.jellyfish.rawValue)
                            .font(.H3)
                            .foregroundStyle(viewModel.showingCharacterType == .jellyfish
                                ? WalkieCommonAsset.gray700.swiftUIColor
                                : WalkieCommonAsset.gray300.swiftUIColor)
                            .padding(4)
                            .onTapGesture {
                                if viewModel.showingCharacterType != .jellyfish {
                                    viewModel.action(.willSelectCategory(.jellyfish))
                                }
                            }
                        Text(CharacterType.dino.rawValue)
                            .font(.H3)
                            .foregroundStyle(viewModel.showingCharacterType == .dino
                                ? WalkieCommonAsset.gray700.swiftUIColor
                                : WalkieCommonAsset.gray300.swiftUIColor)
                            .padding(4)
                            .onTapGesture {
                                if viewModel.showingCharacterType != .dino {
                                    viewModel.action(.willSelectCategory(.dino))
                                }
                            }
                    }.padding(.bottom, 4)
                    Text(viewModel.showingCharacterType == .jellyfish
                        ? StringLiterals.CharacterView.jellyfishIntroductionText
                        : StringLiterals.CharacterView.dinoIntroductionText)
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                    .padding(.bottom, 20)
                    LazyVGrid(columns: gridColumns, alignment: .center, spacing: 11) {
                        if viewModel.showingCharacterType == .jellyfish {
                            ForEach(Array(JellyfishType.allCases), id: \.self) { jellyfish in
                                if let characterState = state.jellyfishState[jellyfish] {
                                    CharacterItemView(
                                        characterImage: jellyfish.getJellyfishImage(),
                                        characterName: jellyfish.rawValue,
                                        characterType: .jellyfish,
                                        count: characterState.count,
                                        isWalking: characterState.isWalking
                                    ).onTapGesture {
                                        viewModel.action(.willSelectJellyfish(jellyfish, state.jellyfishState[jellyfish]!))
                                    }
                                }
                            }
                        } else {
                            ForEach(Array(DinoType.allCases), id: \.self) { dino in
                                if let characterState = state.dinoState[dino] {
                                    CharacterItemView(
                                        characterImage: dino.getDinoImage(),
                                        characterName: dino.rawValue,
                                        characterType: .dino,
                                        count: characterState.count,
                                        isWalking: characterState.isWalking
                                    ).onTapGesture {
                                        viewModel.action(.willSelectDino(dino))
                                    }
                                }
                            }
                        }
                    }
                case .error(let error):
                    Text(error.description)
                default:
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .onAppear {
                viewModel.action(.willAppear)
            }
        }
        .bottomSheet(isPresented: $isPresentingBottomSheet, height: 516) {
            // 바텀시트 구현
        }
    }
    
}

struct CharacterItemView: View {
    @Environment(\.screenWidth) var screenWidth
    
    let characterImage: ImageResource
    let characterName: String
    let characterType: CharacterType
    
    let count: Int
    let isWalking: Bool
    
    let emptyJellyfishImage = ImageResource(name: "img_empty_jellyfish", bundle: .main)
    let emptyDinoImage = ImageResource(name: "img_empty_dino", bundle: .main)
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(count != 0
                ? characterImage
                : characterType == .jellyfish
                ? emptyJellyfishImage
                : emptyDinoImage)
            .resizable()
            .frame(width: 120, height: 120)
            Text(characterName)
                .font(.H5)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .padding(.bottom, 4)
            HighlightTextAttribute(
                text: "\(count)마리",
                textColor: WalkieCommonAsset.gray500.swiftUIColor,
                font: .B2,
                highlightText: "\(count)",
                highlightColor: WalkieCommonAsset.gray700.swiftUIColor,
                highlightFont: .H6)
            .padding(.bottom, 12)
        }
        .frame(width: (screenWidth - 16*2 - 11)/2, height: 192)
        .background(WalkieCommonAsset.gray100.swiftUIColor)
        .cornerRadius(20)
        .overlay {
            if isWalking {
                Image(.icFoot)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(WalkieCommonAsset.blue300.swiftUIColor)
                    .frame(width: 18, height: 18)
                    .alignTo(.topTrailing)
                    .padding(12)
                RoundedRectangle(cornerRadius: 20)
                    .stroke(WalkieCommonAsset.blue300.swiftUIColor, lineWidth: 2)
            }
        }
    }
    
}

#Preview {
    CharacterView(viewModel: CharacterViewModel())
}
