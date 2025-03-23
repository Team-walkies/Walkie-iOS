//
//  EggViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Combine

final class EggViewModel: ViewModelable {
    
    private let eggUseCase: EggUseCase
    private var cancellables = Set<AnyCancellable>()
    
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
        let eggType: EggLiterals
        let nowStep: Int
        let needStep: Int
        let isWalking: Bool
    }
    
    enum Action {
        case willAppear
        case didTapEggDetail(EggState)
    }
    
    init(eggUseCase: EggUseCase) {
        self.eggUseCase = eggUseCase
    }
    
    @Published var state: EggViewState = .loading
    @Published var eggDetailViewModel: EggDetailViewModel?
    
    func action(_ action: Action) {
        switch action {
        case .willAppear:
            // fetchEggListData()
            generateEggListDummyData()
        case .didTapEggDetail(let eggState):
            eggDetailViewModel = EggDetailViewModel(
                eggUseCase: self.eggUseCase,
                eggState: eggState)
        }
    }
    
    func fetchEggListData() {
        eggUseCase.getEggsList()
            .walkieSink(
                with: self,
                receiveValue: { _, entity in
                    let eggsState = EggsState(
                        eggs: entity.map({ eggEntity in
                            EggState(
                                eggId: eggEntity.eggId,
                                eggType: eggEntity.eggType,
                                nowStep: eggEntity.nowStep,
                                needStep: eggEntity.needStep,
                                isWalking: eggEntity.isWalking)
                        }),
                        eggsCount: entity.count)
                    self.state = .loaded(eggsState)
                }, receiveFailure: { _, error in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                })
            .store(in: &cancellables)
    }
    
    // 더미데이터 생성
    func generateEggListDummyData() {
        let eggs = (0..<20).map { index in
            EggState(
                eggId: index,
                eggType: EggLiterals.allCases.randomElement() ?? .epic,
                nowStep: Int.random(in: 0...5000),
                needStep: Int.random(in: 0...5000),
                isWalking: Bool.random()
            )
        }
        let eggsState = EggsState(
            eggs: eggs,
            eggsCount: 20
        )
        self.state = .loaded(eggsState)
    }
}
