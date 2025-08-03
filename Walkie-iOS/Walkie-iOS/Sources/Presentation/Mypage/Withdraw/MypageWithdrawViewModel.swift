//
//  MypageWithdrawViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 6/24/25.
//

import Combine
import Foundation
import WalkieCommon

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
            appCoordinator.buildAlert(
                title: "회원 탈퇴",
                highlightedContent: "탈퇴 시 해당 계정으로 다시 가입할 수 없어요.",
                highlightedColor: WalkieCommonAsset.red100.swiftUIColor,
                content: "탈퇴에 부득이한 사유가 있는 경우,\n 워키 개발팀에 문의해주세요.\n\nwalkieofficial@gmail.com",
                style: .error,
                button: .twobutton,
                cancelButtonAction: {},
                checkButtonAction: {
                    self.withdraw()
                },
                checkButtonTitle: "탈퇴하기",
                cancelButtonTitle: "뒤로가기"
            )
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
