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
    
    var goToRoot: ((Bool) -> Void)?
    
    enum MypageMainViewState {
        case loading
        case loaded(MypageMainState)
        case error(String)
    }
    
    struct MypageMainState {
        var nickname: String
        var userTier: String
        var spotCount: Int
        var isPublic: Bool
    }
    
    enum Action {
        case mypageMainWillAppear
        case toggleMyInformationIsPublic
        case toggleNotifyEggHatches
        case logout
        case withdraw
        case withdrawWillAppear
    }
    
    @Published var state: MypageMainViewState = .loading
    private var mypageState: MypageMainState = MypageMainState(
        nickname: "",
        userTier: "",
        spotCount: 0,
        isPublic: false
    )
    
    private var hasInitialized: Bool = false
    
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
            if !hasInitialized { fetchMypageMainData() }
        case .toggleMyInformationIsPublic:
            updateMyInformationPublicSetting()
        case .toggleNotifyEggHatches:
            updateNotifyEggHatches()
        case .logout:
            logout()
        case .withdraw:
            withdraw()
        case .withdrawWillAppear:
            fetchMypageMainData()
        }
    }
    
    private func fetchMypageMainData() {
        getProfileUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, entity in
                    self.mypageState = MypageMainState(
                        nickname: entity.nickname,
                        userTier: entity.memberTier,
                        spotCount: entity.exploredSpotCount,
                        isPublic: entity.isPublic
                    )
                    self.state = .loaded(self.mypageState)
                    self.hasInitialized = true
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
                receiveValue: { _, _ in
                    self.mypageState.isPublic.toggle()
                    self.state = .loaded(self.mypageState)
                }, receiveFailure: { _, error  in
                    let errorMessage = error?.description ?? "Failed to patch profile visibility"
                    
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
                    self.goToRoot?(true)
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
                    self.goToRoot?(true)
                }, receiveFailure: { _, error  in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            )
            .store(in: &self.cancellables)
    }
}
