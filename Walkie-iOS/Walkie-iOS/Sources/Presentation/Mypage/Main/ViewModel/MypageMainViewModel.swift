//
//  MypageMainViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 2/21/25.
//

import SwiftUI
import Combine

final class MypageMainViewModel: ViewModelable {
    
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
    
    @Published var state: MypageMainViewState
    @Published var myInformationState = MyInformationState(isPublic: false)
    @Published var pushNotificationState = PushNotificationState(
        notifyTodayWalkCount: false,
        notifyArrivedSpot: false,
        notifyEggHatches: false
    )
    
    init() {
        state = .loading
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
        
        if dummy.success, let userData = dummy.data {
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
        // TODO: 내 프로필 공개/비공개 토글 API 연결
        myInformationState.isPublic.toggle()
    }

    private func updateNotifyTodayWalkCount() {
        // TODO: 푸시 알림 토글 API 연결
        pushNotificationState.notifyTodayWalkCount.toggle()
    }
    
    private func updateNotifyArrivedSpot() {
        // TODO: 푸시 알림 토글 API 연결
        pushNotificationState.notifyArrivedSpot.toggle()
    }
    
    private func updateNotifyEggHatches() {
        // TODO: 푸시 알림 토글 API 연결
        pushNotificationState.notifyEggHatches.toggle()
    }
    
    private func logout() {
        // TODO: 로그아웃 API 연결
    }
    
    private func withdraw() {
        // TODO: 탈퇴 API 연결
    }
}
