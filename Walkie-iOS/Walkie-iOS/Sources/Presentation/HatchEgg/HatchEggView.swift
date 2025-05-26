//
//  HatchEggView.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/1/25.
//

import SwiftUI
import Lottie
import WalkieCommon

struct HatchEggView: View {
    
    @StateObject var hatchEggViewModel: HatchEggViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Environment(\.screenHeight) var screenHeight
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(white: 0, opacity: 0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    if hatchEggViewModel.animationState.isShowingGlowEffect {
                        appCoordinator.dismissFullScreenCover()
                    }
                }
            switch hatchEggViewModel.state {
            case .loaded(let hatchState):
                if hatchEggViewModel.animationState.isPlayingConfetti {
                    WalkieLottieView(
                        lottie: WalkieLottie.confetti,
                        isPlaying: hatchEggViewModel.animationState.isPlayingConfetti
                    ).frame(width: screenHeight * 0.54, height: screenHeight * 0.54)
                }
                Image(.glowEffect)
                    .resizable()
                    .frame(width: screenHeight * 0.5, height: screenHeight * 0.5)
                    .opacity(hatchEggViewModel.animationState.isShowingGlowEffect ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: hatchEggViewModel.animationState.isShowingGlowEffect)
                
                switch hatchState.characterType {
                case .jellyfish:
                    Image(hatchState.jellyfishType.getCharacterImage())
                        .frame(width: screenHeight * 0.27, height: screenHeight * 0.27)
                        .opacity(hatchEggViewModel.animationState.isShowingCharacter ? 1 : 0)
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: hatchEggViewModel.animationState.isShowingCharacter)
                case .dino:
                    Image(hatchState.dinoType.getCharacterImage())
                        .frame(width: screenHeight * 0.27, height: screenHeight * 0.27)
                        .opacity(hatchEggViewModel.animationState.isShowingCharacter ? 1 : 0)
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: hatchEggViewModel.animationState.isShowingCharacter)
                }
                let eggLottie = switch hatchState.eggType {
                case .normal:
                    WalkieLottie.eggBlue
                case .rare:
                    WalkieLottie.eggGreen
                case .epic:
                    WalkieLottie.eggYellow
                case .legendary:
                    WalkieLottie.eggPurple
                }
                WalkieLottieView(
                    lottie: eggLottie,
                    isPlaying: hatchEggViewModel.animationState.isPlayingEggLottie
                )
                .frame(width: screenHeight * 0.27, height: screenHeight * 0.27)
                .opacity(hatchEggViewModel.animationState.isShowingEggLottie ? 1 : 0)
                .animation(.easeIn(duration: 0.3), value: !hatchEggViewModel.animationState.isShowingEggLottie)
                .animation(.easeIn(duration: 0.3), value: !hatchEggViewModel.animationState.isShowingEggLottie)
                VStack(alignment: .center, spacing: 0) {
                    Text("잠깐,")
                        .font(.H2)
                        .foregroundStyle(.white)
                        .opacity(hatchEggViewModel.animationState.isShowingWaitText ? 1 : 0)
                        .animation(.easeIn(duration: 0.3), value: hatchEggViewModel.animationState.isShowingWaitText)
                    Text("알이 부화하려고 해요!")
                        .font(.H2)
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)
                        .opacity(hatchEggViewModel.animationState.isShowingEggHatchText ? 1 : 0)
                        .animation(
                            .easeIn(duration: 0.3),
                            value: hatchEggViewModel.animationState.isShowingEggHatchText
                        )
                }
                .alignmentGuide(VerticalAlignment.center) { view in
                    view[.bottom] + 132
                }
                VStack(alignment: .center, spacing: 0) {
                    let characterName = switch hatchState.characterType {
                    case .jellyfish:
                        hatchState.jellyfishType.rawValue
                    case .dino:
                        hatchState.dinoType.rawValue
                    }
                    Text("두둥!")
                        .font(.H2)
                        .foregroundStyle(.white)
                    Text("\(characterName)가 태어났어요")
                        .font(.H2)
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)
                    Text("캐릭터와 함께 걸어보세요")
                        .font(.B2)
                        .foregroundStyle(WalkieCommonAsset.gray300.swiftUIColor)
                }
                .opacity(hatchEggViewModel.animationState.isShowingCharacter ? 1 : 0)
                .animation(.easeIn(duration: 0.3), value: hatchEggViewModel.animationState.isShowingCharacter)
                .alignmentGuide(VerticalAlignment.center) { view in
                    view[.bottom] + 108
                }
            default:
                ProgressView()
            }
        }
        .onAppear { hatchEggViewModel.action(.willAppear)
            scheduleAnimation()
        }
    }
}

extension HatchEggView {
    func scheduleAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            hatchEggViewModel.action(.willShowWaitText)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            hatchEggViewModel.action(.willShowEggHatchText)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            hatchEggViewModel.action(.willShowEggLottie)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            hatchEggViewModel.action(.willPlayEggLottie)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
            hatchEggViewModel.action(.willShowConfettiEffectWithVibration)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.9) {
            hatchEggViewModel.action(.willShowcharacter)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            hatchEggViewModel.action(.willShowGlowEffect)
        }
    }
}

#Preview {
    DIContainer.shared.buildHatchEggView()
}
