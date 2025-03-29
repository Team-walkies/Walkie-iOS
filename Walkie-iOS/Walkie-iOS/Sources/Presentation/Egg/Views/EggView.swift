//
//  EggView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/18/25.
//

import SwiftUI
import WalkieCommon

struct EggView: View {
    
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ObservedObject var viewModel: EggViewModel
    @State var isPresentingGuideView: Bool = false
    @State var isPresentingBottomSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationBar(
                    rightButtonTitle: "안내",
                    showBackButton: true,
                    showRightButton: true,
                    rightButtonEnabled: true,
                    rightButtonShowsEnabledColor: false,
                    rightButtonAction: {
                        isPresentingGuideView = true
                    })
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        switch self.viewModel.state {
                        case .loaded(let state):
                            HStack(alignment: .center, spacing: 8) {
                                Text("보유한 알")
                                    .font(.H2)
                                    .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                                Text("\(state.eggsCount)")
                                    .font(.H2)
                                    .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                                Spacer()
                            }.padding(.bottom, 4)
                            Text("같이 걷고 싶은 알을 선택해 주세요")
                                .font(.B2)
                                .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                                .padding(.bottom, 20)
                            LazyVGrid(columns: gridColumns, alignment: .center, spacing: 11) {
                                ForEach(state.eggs, id: \.eggId) { egg in
                                    EggItemView(state: egg)
                                        .onTapGesture {
                                            viewModel.action(.didTapEggDetail(egg))
                                            isPresentingBottomSheet = true
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
            }
        }
        .navigationDestination(isPresented: $isPresentingGuideView) {
            EggGuideView()
                .navigationBarBackButtonHidden()
        }
        .bottomSheet(isPresented: $isPresentingBottomSheet, height: 516) {
            EggDetailView(viewModel: viewModel.eggDetailViewModel!)
        }
        .navigationBarBackButtonHidden()
    }
}

private struct EggItemView: View {
    
    @Environment(\.screenWidth) var screenWidth
    
    let state: EggViewModel.EggState
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(state.eggType.eggImage)
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Text(state.eggType.rawValue)
                .font(.C1)
                .foregroundStyle(state.eggType.fontColor)
                .frame(width: 37, height: 24)
                .background(.white)
                .cornerRadius(99)
                .padding(.bottom, 8)
            ProgressBarView(
                isSmall: true,
                current: state.nowStep,
                total: state.needStep)
            .padding(.bottom, 8)
            HighlightTextAttribute(
                text: String(format: "%d / %d", locale: Locale.current, state.nowStep, state.needStep),
                textColor: WalkieCommonAsset.gray500.swiftUIColor,
                font: .B1,
                highlightText: String(format: "%d /", locale: Locale.current, state.nowStep),
                highlightColor: WalkieCommonAsset.gray700.swiftUIColor,
                highlightFont: .H5)
            .padding(.bottom, 16)
        }
        .frame(width: (screenWidth - 16*2 - 11)/2, height: 188)
        .background(WalkieCommonAsset.gray100.swiftUIColor)
        .cornerRadius(20)
        .overlay {
            if state.isWalking {
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

#Preview{
    DIContainer.shared.registerEgg()
}
