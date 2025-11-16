//
//  BGTaskManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/30/25.
//

import Foundation
import BackgroundTasks

final class BGTaskManager {
    static let shared = BGTaskManager()
    
    private var stepRefreshHandler: ((BGAppRefreshTask) -> Void)?
    private var stepGoalHandler: ((BGAppRefreshTask) -> Void)?
    
    public init() {}
    
    func registerBackgroundTasks(_ task: WalkieBackgroundTask) {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: task.rawValue, using: nil) { [weak self] task in
            guard let refreshTask = task as? BGAppRefreshTask else { return }
            print("⏳ 백그라운드 테스크 작업 시작 : \(task.identifier) ⏳")
            
            switch task.identifier {
            case WalkieBackgroundTask.step.rawValue:
                if let handler = self?.stepRefreshHandler {
                    handler(refreshTask)
                } else {
                    print("⚠️ step 핸들러가 설정되지 않았습니다 ⚠️")
                    refreshTask.setTaskCompleted(success: false)
                }
            case WalkieBackgroundTask.stepGoal.rawValue:
                if let handler = self?.stepGoalHandler {
                    handler(refreshTask)
                } else {
                    print("⚠️ stepGoal 핸들러가 설정되지 않았습니다 ⚠️")
                    refreshTask.setTaskCompleted(success: false)
                }
            default:
                break
            }
        }
    }
    
    func scheduleAppRefresh(_ task: WalkieBackgroundTask) {
        let request = BGAppRefreshTaskRequest(identifier: task.rawValue)
        request.earliestBeginDate = Date(timeIntervalSinceNow: .leastNonzeroMagnitude)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("⏳ 백그라운드 테스크 스케줄링 완료 : \(task.rawValue) ⏳")
        } catch {
            print("⏳ 백그라운드 테스크 스케줄링 에러 : \(error.localizedDescription) ⏳")
        }
    }
    
    func cancelAll() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: WalkieBackgroundTask.step.rawValue)
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: WalkieBackgroundTask.stepGoal.rawValue)
    }
    
    func setStepRefreshHandler(_ handler: @escaping (BGAppRefreshTask) -> Void) {
        stepRefreshHandler = handler
    }
    
    func setStepGoalHandler(_ handler: @escaping (BGAppRefreshTask) -> Void) {
        stepGoalHandler = handler
    }
}

enum WalkieBackgroundTask: String {
    case step = "com.walkie.ios.step"
    case stepGoal = "com.walkie.ios.step-goal"
}
