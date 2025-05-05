//
//  MypageMainViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI
import Combine

final class MypageMainViewModel: ViewModelable {
    
    private let logoutUseCase: DefaultLogoutUserUseCase
    private let patchProfileUseCase: PatchProfileUseCase
    private let getProfileUseCase: GetProfileUseCase
    private let withdrawUseCase: WithdrawUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    enum MypageMainViewState {
        case loading
        case loaded(MypageMainState)
        case error(String)
    }
    
    struct MypageMainState {
        let nickname: String
        let userTier: String
        let spotCount: Int
    }
    
    enum Action {
        case mypageMainWillAppear
        case toggleMyInformationIsPublic
        case toggleNotifyEggHatches
        case logout
        case withdraw
    }
    
    struct LogoutViewState {
        var isPresented: Bool
    }
    
    @Published var state: MypageMainViewState = .loading
    @Published var logoutViewState = LogoutViewState(isPresented: false)
    
    init(
        logoutUseCase: DefaultLogoutUserUseCase,
        patchProfileUseCase: PatchProfileUseCase,
        getProfileUseCase: GetProfileUseCase,
        withdrawUseCase: WithdrawUseCase
    ) {
        self.logoutUseCase = logoutUseCase
        self.patchProfileUseCase = patchProfileUseCase
        self.getProfileUseCase = getProfileUseCase
        self.withdrawUseCase = withdrawUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .mypageMainWillAppear:
            fetchMypageMainData()
        case .toggleMyInformationIsPublic:
            updateMyInformationPublicSetting()
        case .toggleNotifyEggHatches:
            updateNotifyEggHatches()
        case .logout:
            logout()
        case .withdraw:
            withdraw()
        }
    }
    
    private func fetchMypageMainData() {
        getProfileUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, entity in
                    self.state = .loaded(
                        MypageMainState(
                            nickname: entity.nickname,
                            userTier: entity.memberTier,
                            spotCount: entity.exploredSpotCount,
                        )
                    )
                    
                }, receiveFailure: { _, error  in
                    let errorMessage = error?.description ?? "Failed to fetch user data"
                    self.state = .error(errorMessage)
                }
            )
            .store(in: &cancellables)
    }
    
    private func updateMyInformationPublicSetting() {
        
        patchProfileUseCase.patchProfileVisibility()
            .walkieSink(
                with: self,
                receiveValue: { _, entity in
                    
                }, receiveFailure: { _, error  in
                    let errorMessage = error?.description ?? "Failed to patch profile visibility"
                    self.state = .error(errorMessage)
                    
                }
            )
            .store(in: &cancellables)
    }
    
    private func updateNotifyEggHatches() {
        NotificationManager.shared.toggleNotificationMode()
    }
    
    private func logout() {
        logoutUseCase.postLogout()
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    NotificationCenter.default.post(
                        name: .reissueFailed,
                        object: nil
                    )
                }, receiveFailure: { _, error  in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            )
            .store(in: &self.cancellables)
    }
    
    private func withdraw() {
        withdrawUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    UserManager.shared.withdraw()
                }, receiveFailure: { _, error  in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            )
        .store(in: &self.cancellables)    }
}
