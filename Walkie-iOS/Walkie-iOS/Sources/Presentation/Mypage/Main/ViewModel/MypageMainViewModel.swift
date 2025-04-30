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
        let hasAlarm: Bool
    }
    
    struct MyInformationState {
        var isPublic: Bool
    }
    
    struct PushNotificationState {
        var notifyTodayWalkCount: Bool
        var notifyArrivedSpot: Bool
        var notifyEggHatches: Bool
    }
    
    enum Action {
        case mypageMainWillAppear
        case toggleMyInformationIsPublic
        case toggleNotifyTodayWalkCount
        case toggleNotifyArrivedSpot
        case toggleNotifyEggHatches
        case logout
        case withdraw
    }
    
    struct LogoutViewState {
        var isPresented: Bool
    }
    
    @Published var state: MypageMainViewState
    @Published var myInformationState = MyInformationState(isPublic: false)
    @Published var pushNotificationState = PushNotificationState(
        notifyTodayWalkCount: false,
        notifyArrivedSpot: false,
        notifyEggHatches: false
    )
    @Published var logoutViewState = LogoutViewState(isPresented: false)
    
    init(
        logoutUseCase: DefaultLogoutUserUseCase
    ) {
        state = .loading
        self.logoutUseCase = logoutUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .mypageMainWillAppear:
            fetchMypageMainData()
        case .toggleMyInformationIsPublic:
            updateMyInformationPublicSetting()
        case .toggleNotifyTodayWalkCount:
            updateNotifyTodayWalkCount()
        case .toggleNotifyArrivedSpot:
            updateNotifyArrivedSpot()
        case .toggleNotifyEggHatches:
            updateNotifyEggHatches()
        case .logout:
            logout()
        case .withdraw:
            withdraw()
        }
    }
    
    private func fetchMypageMainData() {
        let dummy = UserInformationResponse.getDummyData()
        
        if dummy.status == 200, let userData = dummy.data {
            let mypageState = MypageMainState(
                nickname: userData.nickname,
                userTier: userData.memberTier,
                spotCount: userData.exploredSpotCount,
                hasAlarm: true // TODO: 알림 조회 API 연결
            )
            self.myInformationState = MyInformationState(isPublic: userData.isPublic)
            self.state = .loaded(mypageState)
        } else {
            self.state = .error(dummy.message)
        }
    }
    
    private func updateMyInformationPublicSetting() {
        myInformationState.isPublic.toggle()
    }

    private func updateNotifyTodayWalkCount() {
        pushNotificationState.notifyTodayWalkCount.toggle()
    }
    
    private func updateNotifyArrivedSpot() {
        pushNotificationState.notifyArrivedSpot.toggle()
    }
    
    private func updateNotifyEggHatches() {
        pushNotificationState.notifyEggHatches.toggle()
    }
    
    private func logout() {
        logoutUseCase.postLogout()
            .walkieSink(
                with: self,
                receiveValue: { _, _ in
                    do {
                        try TokenKeychainManager.shared.removeTokens()
                        UserManager.shared.withdraw()
                        NotificationCenter.default.post(
                            name: .reissueFailed,
                            object: nil
                        )
                    } catch {
                        
                    }
                }, receiveFailure: { _, error  in
                    let errorMessage = error?.description ?? "An unknown error occurred"
                    self.state = .error(errorMessage)
                }
            )
            .store(in: &self.cancellables)
    }
    
    private func withdraw() {
        // TODO: 탈퇴 API 연결
    }
}
