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
        case returnFromPermissionSetting
    }
    
    var coordinator: Coordinator
    var state: State = State()
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func action(_ action: Action) {
        switch action {
        case .returnFromPermissionSetting:
            HealthKitManager.shared.checkReadAuthorizationStatus(
                completion: { permission in
                    switch permission {
                    case .authorized:
                        self.coordinator.pop()
                        self.coordinator.push(AppScene.healthcare)
                    default:
                        break
                    }
                }
            )
        }
    }
}
