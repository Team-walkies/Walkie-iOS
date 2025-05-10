//
//  StepManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/6/25.
//

import Combine
import BackgroundTasks

final class StepManager {
    
    private var cancellables: Set<AnyCancellable> = []
    private let getEggPlayUseCase: GetEggPlayUseCase
    private let updateEggStepUseCase: UpdateEggStepUseCase
    private let checkStepUseCase: CheckStepUseCase
    private let updateStepCacheUseCase: UpdateStepCacheUseCase
    
    private enum BackgroundTaskIdentifier: String, CaseIterable {
        case checkStep = "com.walkie.ios.check.step"
        case updateStep = "com.walkie.ios.update.step"
    }
    
    static let shared = StepManager()
    
    init() {
        self.getEggPlayUseCase = DIContainer.shared.resolveGetEggPlayUseCase()
        self.updateEggStepUseCase = DIContainer.shared.resolveUpdateEggStepUseCase()
        self.checkStepUseCase = DIContainer.shared.resolveCheckStepUseCase()
        self.updateStepCacheUseCase = DIContainer.shared.resolveUpdateStepCacheUseCase()
        
        // 백그라운드 태스크 등록
        registerBackgroundTasks()
    }
    
    func getEggPlayingAndThenUpdateStep() {
        getEggPlayUseCase.execute()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("EggEntity 조회 완료")
                    case .failure(let error):
                        print("EggEntity 조회 오류: \(error)")
                    }
                },
                receiveValue: { [weak self] eggEntityValue in
                    self?.updateEggStepUseCase.execute(
                        egg: eggEntityValue,
                        step: UserManager.shared.getStepCount,
                        willHatch: false
                    )
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Task Execution
    
    func executeForegroundTasks() {
        updateStepCacheUseCase.execute { [self] in
            checkStepUseCase.execute()
            getEggPlayingAndThenUpdateStep()
        }
    }
    
    func executeBackgroundTasks() {
        updateStepCacheUseCase.execute {
            
        }
        scheduleBackgroundTasks()
    }
    
    // MARK: - Background Task Scheduling
    
    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.checkStep.rawValue,
            using: nil
        ) { [weak self] task in
            self?.handleCheckStepTask(task: task)
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.updateStep.rawValue,
            using: nil
        ) { [weak self] task in
            self?.handleUpdateStepTask(task: task)
        }
    }
    
    private func handleCheckStepTask(task: BGTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        checkStepUseCase.execute()
        task.setTaskCompleted(success: true)
        scheduleBackgroundTasks()
    }
    
    private func handleUpdateStepTask(task: BGTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        updateStepCacheUseCase.execute {
            
        }
        task.setTaskCompleted(success: true)
        scheduleBackgroundTasks()
    }
    
    private func scheduleBackgroundTasks() {
        let checkStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.checkStep.rawValue)
        checkStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        
        do {
            try BGTaskScheduler.shared.submit(checkStepRequest)
            print("[DEBUG][StepManager][scheduleBackgroundTasks] CheckStep task scheduled")
        } catch {
            print("[DEBUG][StepManager][scheduleBackgroundTasks] Failed to schedule CheckStep task: \(error)")
        }
        
        let updateStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.updateStep.rawValue)
        updateStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        
        do {
            try BGTaskScheduler.shared.submit(updateStepRequest)
            print("[DEBUG][StepManager][scheduleBackgroundTasks] UpdateStep task scheduled")
        } catch {
            print("[DEBUG][StepManager][scheduleBackgroundTasks] Failed to schedule UpdateStep task: \(error)")
        }
    }
}
