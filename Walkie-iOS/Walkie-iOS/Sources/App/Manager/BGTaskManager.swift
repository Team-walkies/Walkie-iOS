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
    
    public init() {}
    
    // 백그라운드 작업 등록
    func registerBackgroundTasks(_ task: WalkieBackgroundTask, action: @escaping (BGAppRefreshTask) -> Void) {
        Task {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: task.rawValue, using: nil) { task in
                guard let refreshTask = task as? BGAppRefreshTask else { return }
                print("⏳ 백그라운드 테스크 작업 시작 : \(task) ⏳")
                action(refreshTask)
            }
        }
    }
    
    // 가벼운 작업 바로 스케줄링
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
    }
}

enum WalkieBackgroundTask: String {
    case step = "com.walkie.ios.step"
}
