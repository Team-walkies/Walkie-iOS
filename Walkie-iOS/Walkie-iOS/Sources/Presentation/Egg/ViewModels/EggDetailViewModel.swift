//
//  EggDetailViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/24/25.
//

import Combine

final class EggDetailViewModel: ViewModelable {
    
    let eggState: EggViewModel.EggState
    private let eggUseCase: EggUseCase
    private var cancellables = Set<AnyCancellable>()
    
    enum EggDetailViewState {
        case loading
        case loaded(EggViewModel.EggState)
        case error(String)
    }
    
    enum Action {
        case willAppear
        case didSelectEggWalking(completion: () -> Void)
    }
    
    init(eggUseCase: EggUseCase, eggState: EggViewModel.EggState) {
        self.eggUseCase = eggUseCase
        self.eggState = eggState
    }
    
    @Published var state: EggDetailViewState = .loading
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            state = .loaded(self.eggState)
        case .didSelectEggWalking(let completion):
            patchEggWalking(completion: completion)
        }
    }
    
    func patchEggWalking(completion: @escaping () -> Void) {
        eggUseCase.patchEggPlaying(eggId: eggState.eggId)
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    self.state = .loaded(
                        EggViewModel.EggState(
                            eggId: self.eggState.eggId,
                            eggType: self.eggState.eggType,
                            nowStep: self.eggState.nowStep,
                            needStep: self.eggState.needStep,
                            isWalking: true,
                            obtainedPosition: self.eggState.obtainedPosition,
                            obtainedDate: self.eggState.obtainedDate
                        )
                    )
                    completion()
                    ToastManager.shared.showToast("같이 걷는 알을 바꿨어요", icon: .icCheckBlue)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                    completion()
                })
            .store(in: &cancellables)
    }
}
