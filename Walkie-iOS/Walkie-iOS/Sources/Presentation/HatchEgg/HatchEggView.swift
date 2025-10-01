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
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Color(white: 0, opacity: 0.6)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        if hatchEggViewModel.animationState.isDismissAllowed {
                            appCoordinator.dismissFullScreenCover()
                        }
                    }
                switch hatchEggViewModel.state {
                case .loaded(let hatchState):
                    if hatchEggViewModel.animationState.isPlayingConfetti {
                        WalkieLottieView(
                            lottie: WalkieLottie.confetti,
                            isPlaying: hatchEggViewModel.animationState.isPlayingConfetti
                        )
                        .frame(
                            width: geometry.size.height * 0.54,
                            height: geometry.size.height * 0.54
                        )
                        .allowsHitTesting(false)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                    
                    Image(.glowEffect)
                        .resizable()
                        .frame(
                            width: geometry.size.height * 0.5,
                            height: geometry.size.height * 0.5
                        )
                        .allowsHitTesting(false)
                        .fadeAnimation(hatchEggViewModel.animationState.isShowingGlowEffect, duration: 0.2)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    switch hatchState.characterType {
                    case .jellyfish:
                        Image(hatchState.jellyfishType.getCharacterImage())
                            .frame(
                                width: geometry.size.height * 0.27,
                                height: geometry.size.height * 0.27
                            )
                            .fadeAnimation(hatchEggViewModel.animationState.isShowingCharacter, duration: 0.3)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    case .dino:
                        Image(hatchState.dinoType.getCharacterImage())
                            .frame(
                                width: geometry.size.height * 0.27,
                                height: geometry.size.height * 0.27
                            )
                            .fadeAnimation(hatchEggViewModel.animationState.isShowingCharacter, duration: 0.3)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                    
                    let eggLottie = switch hatchState.eggType {
                    case .normal: WalkieLottie.eggBlue
                    case .rare: WalkieLottie.eggGreen
                    case .epic: WalkieLottie.eggYellow
                    case .legendary: WalkieLottie.eggPurple
                    }
                    WalkieLottieView(
                        lottie: eggLottie,
                        isPlaying: hatchEggViewModel.animationState.isPlayingEggLottie
                    )
                    .allowsHitTesting(false)
                    .frame(
                        width: geometry.size.height * 0.27,
                        height: geometry.size.height * 0.27
                    )
                    .fadeAnimation(hatchEggViewModel.animationState.isShowingEggLottie) 
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                    
                    VStack(alignment: .center, spacing: 0) {
                        Text("잠깐,")
                            .font(.H2)
                            .foregroundStyle(.white)
                            .fadeAnimation(hatchEggViewModel.animationState.isShowingWaitText) 
                        Text("알이 부화하려고 해요!")
                            .font(.H2)
                            .foregroundStyle(.white)
                            .padding(.bottom, 4)
                            .fadeAnimation(hatchEggViewModel.animationState.isShowingEggHatchText) 
                    }
                    .allowsHitTesting(false)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - geometry.size.height * 0.27 / 2 - 8 - 92/2)
                    
                    VStack(alignment: .center, spacing: 0) {
                        let characterName = switch hatchState.characterType {
                        case .jellyfish: hatchState.jellyfishType.rawValue
                        case .dino: hatchState.dinoType.rawValue
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
                    .allowsHitTesting(false)
                    .fadeAnimation(hatchEggViewModel.animationState.isShowingCharacter)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - geometry.size.height * 0.27 / 2 - 8 - 92/2)
                    
                default:
                    ProgressView()
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                hatchEggViewModel.action(.willAppear)
                scheduleAnimation()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

extension HatchEggView {
    func scheduleAnimation() {
        withAnimation(.easeInOut(duration: 6.0)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.hatchEggViewModel.action(.willShowWaitText)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.hatchEggViewModel.action(.willShowEggHatchText)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                self.hatchEggViewModel.action(.willShowEggLottie)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                self.hatchEggViewModel.action(.willPlayEggLottie)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
                self.hatchEggViewModel.action(.willShowConfettiEffectWithVibration)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.9) {
                self.hatchEggViewModel.action(.willShowcharacter)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self.hatchEggViewModel.action(.willShowGlowEffect)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                self.hatchEggViewModel.action(.allowDismiss)
            }
        }
    }
}

#Preview {
    DIContainer.shared.buildHatchEggView()
}
