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
    
    enum Action {
        case mypageMainWillAppear
    }
    
    @Published var state: MypageMainViewState
    
    init() {
        state = .loading
    }
    
    func action(_ action: Action) {
        switch action {
        case .mypageMainWillAppear:
            fetchMypageMainData()
        }
    }
    
    func fetchMypageMainData() {
        let dummy = UserInformationResponse.getDummyData()
        
        if dummy.success, let userData = dummy.data {
            let mypageState = MypageMainState(
                nickname: userData.nickname,
                userTier: userData.memberTier,
                spotCount: userData.exploredSpotCount,
                hasAlarm: true // TODO: 알림 조회 API 연결
            )
            self.state = .loaded(mypageState)
        } else {
            self.state = .error(dummy.message)
        }
    }
}
