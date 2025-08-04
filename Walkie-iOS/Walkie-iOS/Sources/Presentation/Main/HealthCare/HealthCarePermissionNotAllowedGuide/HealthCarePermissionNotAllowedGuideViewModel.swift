//
//  HealthCarePermissionNotAllowedGuideViewModel.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import Foundation
import HealthKit

final class HealthCarePermissionNotAllowedGuideViewModel: ViewModelable {
    
    struct State {
    }
    
    enum Action {
        case permitButtonTapped
        case returnFromPermissionSetting
    }
    
    var coordinator: Coordinator
    var state: State = State()
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .permitButtonTapped:
            HealthKitManager.shared.requestHealthKitAuthorization()
        case .returnFromPermissionSetting:
            switch HealthKitManager.shared.checkAuthorizationStatus() {
            case .authorized:
                coordinator.push(AppScene.healthcare)
            default:
                break
            }
        }
    }
    
}
