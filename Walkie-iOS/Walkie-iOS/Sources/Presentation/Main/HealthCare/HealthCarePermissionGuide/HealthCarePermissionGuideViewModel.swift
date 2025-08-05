//
//  HealthCarePermissionGuideViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import Foundation

final class HealthCarePermissionGuideViewModel: ViewModelable {
    
    struct State {
    }
    
    enum Action {
        case checkedButtonTapped
        case returnFromPermissionSetting
    }
    
    var coordinator: Coordinator
    var state: State = State()
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .checkedButtonTapped:
            HealthKitManager.shared.requestHealthKitAuthorization()
        case .returnFromPermissionSetting:
            switch HealthKitManager.shared.checkAuthorizationStatus() {
            case .authorized:
                coordinator.pop()
                coordinator.push(AppScene.healthcare)
            default:
                break
            }
        }
    }
}
