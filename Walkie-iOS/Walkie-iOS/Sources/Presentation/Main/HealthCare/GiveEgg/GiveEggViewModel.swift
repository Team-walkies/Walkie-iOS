//
//  GiveEggViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 9/2/25.
//

import Foundation
import SwiftUI

@Observable
final class GiveEggViewModel: ViewModelable {
    
    struct State {
        var animationState: AnimationState
        let eggType: EggType
    }
    
    struct AnimationState {
        var showsCongratsText: Bool
        var showsGoalText: Bool
        var showsLottie: Bool
        var showsGotEggText: Bool
        var showsWalkEggText: Bool
        var showsEggImage: Bool
        var showsCTAButton: Bool
        var eggOffsetY: CGFloat
    }
    
    enum Action {
        case loaded
        case didTapCTAButton
    }
    
    var coordinator: Coordinator
    var state: State
    
    public init(coordinator: Coordinator, eggType: EggType) {
        self.state = State(
            animationState: AnimationState(
                showsCongratsText: false,
                showsGoalText: false,
                showsLottie: false,
                showsGotEggText: false,
                showsWalkEggText: false,
                showsEggImage: false,
                showsCTAButton: false,
                eggOffsetY: 55.0 
            ),
            eggType: eggType
        )
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .loaded:
            Task { @MainActor in
                guard let self = self as? Self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.state.animationState.showsCongratsText = true
                    self.state.animationState.showsLottie = true
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.state.animationState.showsGoalText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    self.state.animationState.showsCongratsText = false
                    self.state.animationState.showsGoalText = false
                    self.state.animationState.showsGotEggText = true
                    self.state.animationState.showsLottie = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.state.animationState.showsWalkEggText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    self.state.animationState.showsEggImage = true
                    withAnimation(.easeOut(duration: 0.3)) {
                        self.state.animationState.eggOffsetY = 0.0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.state.animationState.showsCTAButton = true
                }
            }
        case .didTapCTAButton:
            coordinator.dismissFullScreenCover()
        }
    }
}
