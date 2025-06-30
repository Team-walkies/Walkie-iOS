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
        var nickname: String
        var userTier: String
        var spotCount: Int
        var isPublic: Bool
    }
    
    enum Action {
        case mypageMainWillAppear
        case logout
    }
    
    private let appCoordinator: AppCoordinator
    private let logoutUseCase: LogoutUserUseCase
    private let getProfileUseCase: GetProfileUseCase
    
    private var cancellables = Set<AnyCancellable>()
    @Published var state: MypageMainViewState = .loading
        
    init(
        appCoordinator: AppCoordinator,
        logoutUseCase: LogoutUserUseCase,
        getProfileUseCase: GetProfileUseCase,
    ) {
        self.appCoordinator = appCoordinator
        self.logoutUseCase = logoutUseCase
        self.getProfileUseCase = getProfileUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .mypageMainWillAppear:
            fetchMypageMainData()
        case .logout:
            logout()
        }
    }
    
    private func fetchMypageMainData() {
        getProfileUseCase.execute().walkieSink(
            with: self,
            receiveValue: { _, entity in
                self.state = .loaded(MypageMainState(
                    nickname: entity.nickname,
                    userTier: entity.memberTier,
                    spotCount: entity.exploredSpotCount,
                    isPublic: entity.isPublic
                ))
            }, receiveFailure: { _, error  in
                let errorMessage = error?.description ?? "Failed to fetch user data"
                self.state = .error(errorMessage)
            }
        )
        .store(in: &cancellables)
    }
    
    private func logout() {
        logoutUseCase.postLogout().walkieSink(
            with: self,
            receiveValue: { _, _ in
                self.appCoordinator.changeToSplash()
            }, receiveFailure: { _, error  in
                let errorMessage = error?.description ?? "An unknown error occurred"
                self.state = .error(errorMessage)
            }
        )
        .store(in: &self.cancellables)
    }
}
