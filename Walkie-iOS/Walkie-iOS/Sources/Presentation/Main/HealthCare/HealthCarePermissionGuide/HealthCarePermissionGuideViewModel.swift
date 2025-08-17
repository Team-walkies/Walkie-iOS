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
                if permission {
                    // 허용한 경우
                    self.coordinator.push(AppScene.healthcare)
                } else {
                    // 비허용 혹은 요청 실패한 경우
                    print("권한 요청 실패")
                }
            }
        }
    }
}
