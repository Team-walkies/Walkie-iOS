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
        let dummy = MypageMainState(nickname: "유저이름", userTier: "초보워키", spotCount: 10, hasAlarm: true)
        self.state = .loaded(dummy)
    }
}
