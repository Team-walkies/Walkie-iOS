//
//  MypageWithdrawViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 6/24/25.
//

import Combine
import Foundation

final class MypageWithdrawViewModel: ViewModelable {
    
    struct State {
        let nickname: String
    }
    
    enum Action {
        case willWithdraw
        case didTapBackButton
    }
    
    private let appCoordinator: AppCoordinator
    private let withdrawUseCase: WithdrawUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var state: State
    
    init(appCoordinator: AppCoordinator, withdrawUseCase: WithdrawUseCase, nickname: String) {
        self.appCoordinator = appCoordinator
        self.withdrawUseCase = withdrawUseCase
        self.state = State(nickname: nickname)
    }
    
    func action(_ action: Action) {
        switch action {
        case .willWithdraw:
            withdraw()
        case .didTapBackButton:
            appCoordinator.pop()
        }
    }

    private func withdraw() {
        withdrawUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    self.appCoordinator.popToRoot()
                }, receiveFailure: { _, error  in
                    dump(error)
                    self.appCoordinator.pop()
                }
            )
            .store(in: &self.cancellables)
    }
}
