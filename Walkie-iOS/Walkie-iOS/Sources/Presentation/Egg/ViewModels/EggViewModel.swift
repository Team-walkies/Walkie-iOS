//
//  EggViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class EggViewModel: ViewModelable {
    
    private let getEggListUseCase: GetEggListUseCase
    private let patchEggPlayingUseCase: PatchEggPlayingUseCase
    private var cancellables = Set<AnyCancellable>()
    private let appCoordinator: AppCoordinator
    
    enum EggViewState {
        case loading
        case loaded(EggsState)
        case error(String)
    }
    
    struct EggsState {
        let eggs: [EggState]
        let eggsCount: Int
    }
    
    struct EggState {
        let eggId: Int
        let eggType: EggType
        let nowStep: Int
        let needStep: Int
        let isWalking: Bool
        let obtainedPosition: String
        let obtainedDate: String
    }
    
    enum Action {
        case willAppear
        case didTapEggDetail(EggState)
    }
    
    init(
        getEggListUseCase: GetEggListUseCase,
        patchEggPlayingUseCase: PatchEggPlayingUseCase,
        appCoordinator: AppCoordinator
    ) {
        self.patchEggPlayingUseCase = patchEggPlayingUseCase
        self.getEggListUseCase = getEggListUseCase
        self.appCoordinator = appCoordinator
    }
    
    @Published var state: EggViewState = .loading
    @Published var eggDetailViewModel: EggDetailViewModel?
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            fetchEggListData()
        case .didTapEggDetail(let eggState):
            eggDetailViewModel = EggDetailViewModel(
                patchEggPlayingUseCase: patchEggPlayingUseCase,
                eggState: eggState,
                eggViewModel: self,
                appCoordinator: appCoordinator
            )
        }
    }
    
    func fetchEggListData() {
        getEggListUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, entity in
                    let eggsState = EggsState(
                        eggs: entity.map({ (egg, detail) in
                            EggState(
                                eggId: egg.eggId,
                                eggType: egg.eggType,
                                nowStep: egg.nowStep,
                                needStep: egg.needStep,
                                isWalking: egg.isWalking,
                                obtainedPosition: detail.obtainedPosition,
                                obtainedDate: detail.obtainedDate
                            )
                        }),
                        eggsCount: entity.count)
                        self.state = .loaded(eggsState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                })
            .store(in: &cancellables)
    }
}
