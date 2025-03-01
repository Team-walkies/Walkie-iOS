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
    
    enum Action {
        case mypageMainWillAppear
        case toggleMyInformationIsPublic
    }
    
    @Published var state: MypageMainViewState
    @Published var myInformationState = MyInformationState(isPublic: false)

    init() {
        state = .loading
    }
    
    func action(_ action: Action) {
        switch action {
        case .mypageMainWillAppear:
            fetchMypageMainData()
        case .toggleMyInformationIsPublic:
            updateMyInformationPublicSetting()
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

}
