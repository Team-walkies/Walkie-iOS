//
//  HealthCarePermissionViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import Foundation

final class HealthCarePermissionViewModel: ViewModelable {
    
    struct State {
    }
    
    enum Action {
        case checkedButtonTapped
    }
    
    var coordinator: Coordinator
    var state: State
    
    public init(coordinator: Coordinator) {
        self.state = State()
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .checkedButtonTapped:
            HealthKitManager.shared.requestHealthKitAuthorization { permission in
                dump(permission)
                switch permission {
                case .authorized: // 요청 - 허용
                    self.coordinator.pop()
                    self.coordinator.push(AppScene.healthcare)
                default: // 요청 - 무시 or 거부
                    self.coordinator.pop()
                }
            }
        }
    }
}
