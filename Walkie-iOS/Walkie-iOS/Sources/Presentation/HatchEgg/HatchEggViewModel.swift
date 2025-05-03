//
//  HatchEggViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/1/25.
//

import UIKit

final class HatchEggViewModel: ViewModelable {
    
    private let hatchEggUseCase: HatchEggUseCase
    
    enum Action {
        case willAppear // 0초
        case willShowWaitText // 0.4초
        case willShowEggHatchText // 0.7초
        case willShowEggLottie // 1.3초
        case willPlayEggLottie // 1.8초
        case willShowConfettiEffectWithVibration // 3.7초
        case willShowcharacter // 3.9초
        case willShowGlowEffect // 4초
    }
    
    enum State {
        case loading
        case loaded(HatchEggState)
        case error(String)
    }
    
    struct HatchEggState {
        let eggId: Int
        let eggType: EggType
        let characterType: CharacterType
        let jellyfishType: JellyfishType
        let dinoType: DinoType
    }
    
    struct AnimationState {
        let isShowingWaitText: Bool
        let isShowingEggHatchText: Bool
        let isShowingEggLottie: Bool
        let isPlayingEggLottie: Bool
        let isPlayingConfetti: Bool
        let isShowingCharacter: Bool
        let isShowingGlowEffect: Bool
    }
    
    @Published var state: State = .loaded(
        HatchEggState(eggId: 1, eggType: .normal, characterType: .dino, jellyfishType: .bunny, dinoType: .melonSoda))
    @Published var animationState: AnimationState = .init(
        isShowingWaitText: false,
        isShowingEggHatchText: false,
        isShowingEggLottie: false,
        isPlayingEggLottie: false,
        isPlayingConfetti: false,
        isShowingCharacter: false,
        isShowingGlowEffect: false
    )
    
    init(hatchEggUseCase: HatchEggUseCase) {
        self.hatchEggUseCase = hatchEggUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchHatchEgg()
        case .willShowWaitText:
            self.animationState = .init(
                isShowingWaitText: true,
                isShowingEggHatchText: false,
                isShowingEggLottie: false,
                isPlayingEggLottie: false,
                isPlayingConfetti: false,
                isShowingCharacter: false,
                isShowingGlowEffect: false
            )
        case .willShowEggHatchText:
            self.animationState = .init(
                isShowingWaitText: true,
                isShowingEggHatchText: true,
                isShowingEggLottie: false,
                isPlayingEggLottie: false,
                isPlayingConfetti: false,
                isShowingCharacter: false,
                isShowingGlowEffect: false
            )
        case .willShowEggLottie:
            self.animationState = .init(
                isShowingWaitText: true,
                isShowingEggHatchText: true,
                isShowingEggLottie: true,
                isPlayingEggLottie: false,
                isPlayingConfetti: false,
                isShowingCharacter: false,
                isShowingGlowEffect: false
            )
        case .willPlayEggLottie:
            self.animationState = .init(
                isShowingWaitText: true,
                isShowingEggHatchText: true,
                isShowingEggLottie: true,
                isPlayingEggLottie: true,
                isPlayingConfetti: false,
                isShowingCharacter: false,
                isShowingGlowEffect: false
            )
        case .willShowConfettiEffectWithVibration:
            self.animationState = .init(
                isShowingWaitText: false,
                isShowingEggHatchText: false,
                isShowingEggLottie: false,
                isPlayingEggLottie: false,
                isPlayingConfetti: true,
                isShowingCharacter: false,
                isShowingGlowEffect: false
            )
        case .willShowcharacter:
            self.animationState = .init(
                isShowingWaitText: false,
                isShowingEggHatchText: false,
                isShowingEggLottie: false,
                isPlayingEggLottie: false,
                isPlayingConfetti: true,
                isShowingCharacter: true,
                isShowingGlowEffect: false
            )
        case .willShowGlowEffect:
            self.animationState = .init(
                isShowingWaitText: false,
                isShowingEggHatchText: false,
                isShowingEggLottie: false,
                isPlayingEggLottie: false,
                isPlayingConfetti: true,
                isShowingCharacter: true,
                isShowingGlowEffect: true
            )
        }
    }
    
    private func fetchHatchEgg() {
        hatchEggUseCase.hatchEgg()
    }
}
