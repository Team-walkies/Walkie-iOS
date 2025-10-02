//
//  GiveEggView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 9/2/25.
//

import SwiftUI
import WalkieCommon

struct GiveEggView: View {
    
    @StateObject var viewModel: GiveEggViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                CongratsTextLayer(viewModel: viewModel)
                LottieLayer(viewModel: viewModel, geometry: geometry)
                EggImageLayer(viewModel: viewModel, geometry: geometry)
                EggTextLayer(viewModel: viewModel, geometry: geometry)
                CTAButtonLayer(viewModel: viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(WalkieCommonAsset.blue50.swiftUIColor)
            .onAppear {
                viewModel.action(.loaded)
            }
        }
    }
}

struct CongratsTextLayer: View {
    let viewModel: GiveEggViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("축하해요!")
                .font(.H2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .fadeAnimation(viewModel.state.animationState.showsCongratsText)
            Text("목표 걸음을 다 채웠어요!")
                .font(.H2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .fadeAnimation(viewModel.state.animationState.showsGoalText)
        }
    }
}

struct LottieLayer: View {
    let viewModel: GiveEggViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        WalkieLottieView(
            lottie: .giveEggConfetti,
            isPlaying: viewModel.state.animationState.showsLottie,
            isLoop: false
        )
        .fadeAnimation(viewModel.state.animationState.showsLottie)
        .frame(height: geometry.size.height*0.8)
    }
}

struct EggImageLayer: View {
    let viewModel: GiveEggViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        Image(viewModel.state.eggType.eggImage)
            .resizable()
            .frame(width: geometry.size.height*0.27, height: geometry.size.height*0.27)
            .fadeAnimation(viewModel.state.animationState.showsEggImage, animationType: .easeOut)
            .offset(y: viewModel.state.animationState.eggOffsetY)
    }
}

struct EggTextLayer: View {
    let viewModel: GiveEggViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Text("\(viewModel.state.eggType.rawValue) 알 획득!")
                .font(.H2)
                .foregroundStyle(WalkieCommonAsset.gray700.swiftUIColor)
                .fadeAnimation(viewModel.state.animationState.showsGotEggText)
            Text(getEggSubtitle(for: viewModel.state.eggType))
                .font(.B1)
                .foregroundStyle(WalkieCommonAsset.gray500.swiftUIColor)
                .fadeAnimation(viewModel.state.animationState.showsWalkEggText)
        }
        .offset(y: -(geometry.size.height*0.27 + 62)/2 - 38)
    }
}

struct CTAButtonLayer: View {
    let viewModel: GiveEggViewModel
    
    var body: some View {
        CTAButton(
            title: "확인",
            style: .primary,
            size: .large,
            isEnabled: viewModel.state.animationState.showsCTAButton,
            buttonAction: {
                viewModel.action(.didTapCTAButton)
            }
        )
        .fadeAnimation(viewModel.state.animationState.showsCTAButton)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 38)
    }
}

extension EggTextLayer {
    func getEggSubtitle(for eggType: EggType) -> String {
        switch eggType {
        case .normal:
            "걸어서 알을 부화시켜 보세요"
        case .rare:
            "평소보다 더 희귀한 알이에요"
        case .epic:
            "보기 드문 비범한 알이에요"
        case .legendary:
            "축하해요! 전설로만 듣던 알이에요"
        }
    }
}
