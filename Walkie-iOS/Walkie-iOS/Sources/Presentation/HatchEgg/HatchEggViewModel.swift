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
        case willAppear
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
    
    @Published var state: State = .loading
    
    init(hatchEggUseCase: HatchEggUseCase) {
        self.hatchEggUseCase = hatchEggUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchHatchEgg()
        }
    }
    
    private func fetchHatchEgg() {
        hatchEggUseCase.hatchEgg()
    }
}
