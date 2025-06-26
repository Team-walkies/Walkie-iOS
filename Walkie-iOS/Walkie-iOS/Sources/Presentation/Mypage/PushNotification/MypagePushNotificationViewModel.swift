//
//  MypagePushNotificationViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 6/24/25.
//

import Combine

final class MypagePushNotificationViewModel: ViewModelable {
    struct State {
        var showNotificationPermissionAlert: Bool = false
        var notifyEggHatches: Bool
    }
    
    enum Action {
        case toggleNotifyEggHatches
        case checkNotificationPermissionAndApply
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
        case .checkNotificationPermissionAndApply:
            checkNotificationPermissionAndApply()
        case .didTapBackButton:
            appCoordinator.pop()
        case .openSettings:
            openSettings()
        }
    }
    
    private func toggleNotifyEggHatches() {
        self.state.notifyEggHatches.toggle()
        NotificationManager.shared.setNotificationMode(self.state.notifyEggHatches)
    }
    
    private func openSettings() {
        NotificationManager.shared.checkNotificationPermission { permission in
            switch permission {
            case .notDetermined:
                /// 초기 설정을 무시한 notDetermined의 경우에만 권한 재요청 동작 가능
                NotificationManager.shared.requestAuthorization()
            default:
                NotificationManager.shared.openSettings()
            }
        }
    }
    
    private func checkNotificationPermissionAndApply() {
        NotificationManager.shared.checkNotificationPermission { permission in
            if case .denied = permission {
                /// iOS 설정 상 Off인 경우 무조건 반영
                self.state.notifyEggHatches = false
                NotificationManager.shared.setNotificationMode(false)
            }
            /// 알럿 활성화 상태 업데이트
            self.state.showNotificationPermissionAlert = permission != .authorized
        }
    }
}
