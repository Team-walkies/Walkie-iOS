//
//  MypageMyInformationViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 6/24/25.
//

import Combine

final class MypageMyInformationViewModel: ViewModelable {
    
    struct State {
        var isPublic: Bool
        var nickname: String
    }
    
    enum Action {
        case togglePublicSetting
        case didTapBackButton
        case didTapChangeNicknameButton
        case willChangeNickname(String)
    }
    
    private let appCoordinator: AppCoordinator
    private let patchProfileUseCase: PatchProfileUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var state: State
    
    init(
        appCoordinator: AppCoordinator,
        patchProfileUseCase: PatchProfileUseCase,
        isPublic: Bool,
        nickname: String
    ) {
        self.appCoordinator = appCoordinator
        self.patchProfileUseCase = patchProfileUseCase
        self.state = State(
            isPublic: isPublic,
            nickname: nickname
        )
    }
    
    func action(_ action: Action) {
        switch action {
        case .togglePublicSetting:
            self.togglePublicSetting()
        case .didTapBackButton:
            self.appCoordinator.pop()
        case .didTapChangeNicknameButton:
            self.appCoordinator.push(AppScene.changeNickname(viewModel: self))
        case let .willChangeNickname(nickname):
            self.changeNickname(to: nickname)
        }
    }
    
    private func togglePublicSetting() {
        patchProfileUseCase.patchProfileVisibility().walkieSink(
            with: self,
            receiveValue: { _, _ in
                self.state = .init(
                    isPublic: !self.state.isPublic,
                    nickname: self.state.nickname
                )
            }, receiveFailure: { _, error in
                dump(#function)
                dump(error)
                return
            }
        ).store(in: &cancellables)
    }
    
    private func changeNickname(to nickname: String) {
        patchProfileUseCase.patchProfileNickname(nickname: nickname).walkieSink(
            with: self,
            receiveValue: { _, _ in
                self.state = .init(
                    isPublic: self.state.isPublic,
                    nickname: nickname
                )
                UserManager.shared.setUserNickname(nickname)
                self.appCoordinator.pop()
            }, receiveFailure: { _, error in
                dump(#function)
                dump(error)
                return
            }
        ).store(in: &cancellables)
    }
}
