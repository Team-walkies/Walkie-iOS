//
//  MypagePushNotificationViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 6/24/25.
//

import Combine

final class MypagePushNotificationViewModel: ViewModelable {
    struct State {
        var notifyEggHatches: Bool
        var redirectedToSettingsByApplication: Bool = false
    }
    
    enum Action {
        case toggleNotifyEggHatches
        case updatedNotificationPermission
        case didTapBackButton
        case openSettings
    }
    
    private let appCoordinator: AppCoordinator
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var state: State
    
    init(appCoordinator: AppCoordinator, notifyEggHatches: Bool) {
        self.appCoordinator = appCoordinator
        self.state = State(notifyEggHatches: notifyEggHatches)
    }
    
    func action(_ action: Action) {
        switch action {
        case .toggleNotifyEggHatches:
            toggleNotifyEggHatches()
        case .updatedNotificationPermission:
            checkNotificationPermission()
        case .didTapBackButton:
            appCoordinator.pop()
        case .openSettings:
            openSettings()
        }
    }
    
    private func toggleNotifyEggHatches() {
        if state.notifyEggHatches {
            /// 워키 마이페이지 - 알림 끄기
            self.state.notifyEggHatches = false
            NotificationManager.shared.setNotificationMode(false)
        } else {
            /// iOS 설정 - 알림 설정 확인
            NotificationManager.shared.checkNotificationPermission { permission in
                if permission {
                    /// 워키 마이페이지 - 알림 켜기
                    self.state.notifyEggHatches = permission
                    NotificationManager.shared.setNotificationMode(permission)
                } else {
                    /// iOS 설정 - 알림 설정 창 리디렉션
                    self.openSettings()
                    self.state.redirectedToSettingsByApplication = true
                }
            }
        }
    }
    
    private func openSettings() {
        NotificationManager.shared.openSettings()
    }
    
    private func checkNotificationPermission() {
        NotificationManager.shared.checkNotificationPermission { permission in
            if !permission {
                /// iOS 설정 상 Off인 경우 무조건 반영
                self.state.notifyEggHatches = permission
                NotificationManager.shared.setNotificationMode(permission)
            }
            if case true = self.state.redirectedToSettingsByApplication {
                /// On을 위해 리디렉션 된 경우에만 반영
                self.state.notifyEggHatches = permission
                NotificationManager.shared.setNotificationMode(permission)
                /// 리디렉션 상태 초기화
                self.state.redirectedToSettingsByApplication = false
            }
        }
    }
}
