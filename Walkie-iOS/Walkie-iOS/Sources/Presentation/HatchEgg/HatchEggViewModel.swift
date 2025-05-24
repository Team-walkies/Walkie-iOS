//
//  HatchEggViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/1/25.
//

import UIKit
import Combine
import SwiftUICore

final class HatchEggViewModel: ViewModelable {
    
    private let getEggPlayUseCase: GetEggPlayUseCase
    private let updateEggStepUseCase: UpdateEggStepUseCase
    @EnvironmentObject private var appCoordinator: AppCoordinator
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    @Published var state: State = .loading
    var hatchEggState: EggEntity?
    @Published var animationState: AnimationState = .init(
        isShowingWaitText: false,
        isShowingEggHatchText: false,
        isShowingEggLottie: false,
        isPlayingEggLottie: false,
        isPlayingConfetti: false,
        isShowingCharacter: false,
        isShowingGlowEffect: false
    )
    
    init(
        getEggPlayUseCase: GetEggPlayUseCase,
        updateEggStepUseCase: UpdateEggStepUseCase
    ) {
        self.getEggPlayUseCase = getEggPlayUseCase
        self.updateEggStepUseCase = updateEggStepUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            getEggPlaying()
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
    
    private func getEggPlaying() {
        getEggPlayUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, data in
                    self.hatchEggState = data
                    self.state = .loaded(
                        HatchEggState(
                            eggType: data.eggType,
                            characterType: data.characterType ?? .dino,
                            jellyfishType: data.jellyFishType ?? .defaultJellyfish,
                            dinoType: data.dinoType ?? .defaultDino
                        )
                    )
                    self.hatchEgg()
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            ).store(in: &cancellables)
    }
    
    private func hatchEgg() {
        guard let data = hatchEggState else {
            print(" --- 알 정보 불러오기 실패 --- ")
            return
        }
        updateEggStepUseCase
            .execute(
                egg: data,
                step: data.needStep,
                willHatch: true) {
                    
                }
    }
}
