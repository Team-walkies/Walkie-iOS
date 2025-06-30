//
//  CharacterView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/28/25.
//

import SwiftUI
import WalkieCommon

struct CharacterView: View {
    @Environment(\.screenHeight) var screenHeight
    
    @StateObject var viewModel: CharacterViewModel
    @State var isPresentingBottomSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                NavigationBar(showBackButton: true)
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(spacing: 0) {
                            Text("부화한 캐릭터")
                                .font(.H2)
                                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                                .padding(.top, 12)
                                .padding(.bottom, 22)
                            HStack(alignment: .center, spacing: 8) {
                                Text(CharacterType.jellyfish.rawValue)
                                    .font(.H3)
                                    .foregroundStyle(
                                        viewModel.showingCharacterType == .jellyfish
                                        ? WalkieCommonAsset.gray700.swiftUIColor
                                        : WalkieCommonAsset.gray300.swiftUIColor)
                                    .padding(4)
                                    .onTapGesture {
                                        viewModel.action(.willSelectCategory(.jellyfish))
                                    }
                                Text(CharacterType.dino.rawValue)
                                    .font(.H3)
                                    .foregroundStyle(
                                        viewModel.showingCharacterType == .dino
                                        ? WalkieCommonAsset.gray700.swiftUIColor
                                        : WalkieCommonAsset.gray300.swiftUIColor)
                                    .padding(4)
                                    .onTapGesture {
                                        viewModel.action(.willSelectCategory(.dino))
                                    }
                            }.padding(.bottom, 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        CharacterListView(
                            viewModel: viewModel,
                            isPresentingBottomSheet: $isPresentingBottomSheet
                        )
                        .ignoresSafeArea()
                        .padding(.bottom, 48)
                    }
                    .onAppear {
                        viewModel.action(.willAppear)
                    }
                }.scrollIndicators(.never)
            }
            .bottomSheet(
                isPresented: $isPresentingBottomSheet,
                height: screenHeight-94
            ) {
                CharacterDetailView(viewModel: viewModel.characterDetailViewModel!)
                    .padding(.top, 28)
                    .background(.white)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

private struct CharacterItemView: View {
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
            Image(
                count != 0
                ? characterImage
                : characterType == .jellyfish
                ? emptyJellyfishImage
                : emptyDinoImage)
            .resizable()
            .frame(width: 120, height: 120)
            Text(count == 0 ? "미획득" : characterName)
                .font(.H5)
                .foregroundStyle(
                    count == 0
                    ? WalkieCommonAsset.gray500.swiftUIColor
                    : WalkieCommonAsset.gray700.swiftUIColor
                )
                .padding(.bottom, 4)
            if count == 0 {
                Text("알을 부화시켜 얻어요")
                    .font(.B2)
                    .foregroundStyle(WalkieCommonAsset.gray400.swiftUIColor)
                    .padding(.bottom, 12)
            } else {
                HighlightTextAttribute(
                    text: "\(count)마리",
                    textColor: WalkieCommonAsset.gray500.swiftUIColor,
                    font: .B2,
                    highlightText: "\(count)",
                    highlightColor: WalkieCommonAsset.gray700.swiftUIColor,
                    highlightFont: .H6
                ).padding(.bottom, 12)
            }
        }
        .frame(width: (screenWidth - 16*2 - 11)/2, height: 192)
        .background(WalkieCommonAsset.gray100.swiftUIColor)
        .cornerRadius(20, corners: .allCorners)
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
                    .inset(by: 1)
                    .stroke(WalkieCommonAsset.blue300.swiftUIColor, lineWidth: 2)
            }
        }
    }
    
}

private struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterViewModel
    @Binding var isPresentingBottomSheet: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(CharacterType.allCases, id: \.self) { type in
                    CharacterTypeView(
                        type: type,
                        viewModel: viewModel,
                        isPresentingBottomSheet: $isPresentingBottomSheet
                    )
                }
            }.scrollTargetLayout()
        }
        .scrollPosition(id: $viewModel.showingCharacterType)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.never)
        .animation(.easeInOut(duration: 0.25), value: viewModel.showingCharacterType)
    }
}

private struct CharacterTypeView: View {
    let type: CharacterType
    @ObservedObject var viewModel: CharacterViewModel
    @Binding var isPresentingBottomSheet: Bool
    @Environment(\.screenWidth) var screenWidth
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(
                type == .jellyfish
                ? StringLiterals.CharacterView.jellyfishIntroductionText
                : StringLiterals.CharacterView.dinoIntroductionText
            )
            .font(.B2)
            .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
            .padding(.bottom, 20)
            
            switch viewModel.state {
            case let .loaded(state):
                characterGrid(state: state)
            default:
                skeletonGrid()
            }
        }
        .padding(.horizontal, 16)
        .frame(width: screenWidth)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func characterGrid(state: CharacterViewModel.CharacterListState) -> some View {
        let characters: [AnyHashable] = type == .jellyfish
        ? Array(JellyfishType.allCases)
        : Array(DinoType.allCases)
        
        let chunked = stride(from: 0, to: characters.count, by: 2).map {
            Array(characters[$0..<min($0 + 2, characters.count)])
        }
        
        VStack(spacing: 11) {
            ForEach(chunked.indices, id: \.self) { rowIndex in
                HStack(spacing: 11) {
                    ForEach(chunked[rowIndex], id: \.self) { character in
                        if let jellyfish = character as? JellyfishType {
                            JellyfishItemView(
                                jellyfish: jellyfish,
                                state: state,
                                viewModel: viewModel,
                                isPresentingBottomSheet: $isPresentingBottomSheet
                            )
                            .frame(width: (screenWidth - 16*2 - 11)/2)
                        } else if let dino = character as? DinoType {
                            DinoItemView(
                                dino: dino,
                                state: state,
                                viewModel: viewModel,
                                isPresentingBottomSheet: $isPresentingBottomSheet
                            )
                            .frame(width: (screenWidth - 16*2 - 11)/2)
                        }
                    }
                    if chunked[rowIndex].count == 1 {
                        Spacer()
                            .frame(width: (screenWidth - 16*2 - 11)/2)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func skeletonGrid() -> some View {
        let items = Array(0..<10)
        let chunked = stride(from: 0, to: items.count, by: 2).map {
            Array(items[$0..<min($0 + 2, items.count)])
        }
        VStack(spacing: 11) {
            ForEach(chunked.indices, id: \.self) { rowIndex in
                HStack(spacing: 11) {
                    ForEach(chunked[rowIndex], id: \.self) { _ in
                        CharacterItemSkeletonView()
                            .frame(width: (screenWidth - 16*2 - 11)/2)
                    }
                    if chunked[rowIndex].count == 1 {
                        Spacer()
                            .frame(width: (screenWidth - 16*2 - 11)/2)
                    }
                }
            }
        }
    }
}

private struct JellyfishItemView: View {
    let jellyfish: JellyfishType
    let state: CharacterViewModel.CharacterListState
    let viewModel: CharacterViewModel
    @Binding var isPresentingBottomSheet: Bool
    
    var body: some View {
        if let jellyfishState = state.jellyfishState[jellyfish] {
            CharacterItemView(
                characterImage: jellyfish.getCharacterImage(),
                characterName: jellyfish.rawValue,
                characterType: .jellyfish,
                count: jellyfishState.count,
                isWalking: jellyfishState.isWalking
            )
            .onTapGesture {
                if jellyfishState.count == 0 { return }
                isPresentingBottomSheet = true
                viewModel.action(.willSelectJellyfish(
                    type: jellyfish,
                    state: jellyfishState)
                )
            }
        }
    }
}

private struct DinoItemView: View {
    let dino: DinoType
    let state: CharacterViewModel.CharacterListState
    let viewModel: CharacterViewModel
    @Binding var isPresentingBottomSheet: Bool
    
    var body: some View {
        if let dinoState = state.dinoState[dino] {
            CharacterItemView(
                characterImage: dino.getCharacterImage(),
                characterName: dino.rawValue,
                characterType: .dino,
                count: dinoState.count,
                isWalking: dinoState.isWalking
            )
            .onTapGesture {
                if dinoState.count == 0 { return }
                isPresentingBottomSheet = true
                viewModel.action(.willSelectDino(
                    type: dino,
                    state: dinoState)
                )
            }
        }
    }
}
