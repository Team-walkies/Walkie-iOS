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
    
    static let shared = StepManager(diContainer: DIContainer.shared)
    
    init(diContainer: DIContainer) {
        self.getEggPlayUseCase = diContainer.resolveGetEggPlayUseCase()
        self.updateEggStepUseCase = diContainer.resolveUpdateEggStepUseCase()
        self.checkStepUseCase = diContainer.resolveCheckStepUseCase()
        self.updateStepCacheUseCase = diContainer.resolveUpdateStepCacheUseCase()
        
        // 백그라운드 태스크 등록
        registerBackgroundTasks()
    }
    
    init(
        getEggPlayUseCase: GetEggPlayUseCase,
        updateEggStepUseCase: UpdateEggStepUseCase,
        checkStepUseCase: CheckStepUseCase,
        updateStepCacheUseCase: UpdateStepCacheUseCase
    ) {
        self.getEggPlayUseCase = getEggPlayUseCase
        self.updateEggStepUseCase = updateEggStepUseCase
        self.checkStepUseCase = checkStepUseCase
        self.updateStepCacheUseCase = updateStepCacheUseCase
        
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
        print("[DEBUG][StepManager][executeForegroundTasks] Executing UpdateStepUseCase...")
        updateStepCacheUseCase.execute()
        print("[DEBUG][StepManager][executeForegroundTasks] UpdateStepUseCase completed")
        
        print("[DEBUG][StepManager][executeForegroundTasks] Executing CheckStepUseCase...")
        checkStepUseCase.execute()
        print("[DEBUG][StepManager][executeForegroundTasks] CheckStepUseCase completed")
    }
    
    func executeBackgroundTasks() {
        print("[DEBUG][StepManager][executeBackgroundTasks] Executing UpdateStepUseCase...")
        updateStepCacheUseCase.execute()
        print("[DEBUG][StepManager][executeBackgroundTasks] UpdateStepUseCase completed")
        
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
        
        print("[DEBUG][StepManager][registerBackgroundTasks] Background tasks registered")
    }
    
    private func handleCheckStepTask(task: BGTask) {
        print("[DEBUG][StepManager][handleCheckStepTask] "
              + "Starting checkStep background task on thread: \(Thread.isMainThread ? "Main" : "Background")")
        
        task.expirationHandler = {
            print("[DEBUG][StepManager][handleCheckStepTask] CheckStep task expired")
            task.setTaskCompleted(success: false)
        }
        
        checkStepUseCase.execute()
        print("[DEBUG][StepManager][handleCheckStepTask] CheckStepUseCase executed")
        
        task.setTaskCompleted(success: true)
        scheduleBackgroundTasks()
    }
    
    private func handleUpdateStepTask(task: BGTask) {
        print("[DEBUG][StepManager][handleUpdateStepTask] "
              + "Starting updateStep background task on thread: \(Thread.isMainThread ? "Main" : "Background")")
        
        task.expirationHandler = {
            print("[DEBUG][StepManager][handleUpdateStepTask] UpdateStep task expired")
            task.setTaskCompleted(success: false)
        }
        
        updateStepCacheUseCase.execute()
        print("[DEBUG][StepManager][handleUpdateStepTask] UpdateStepUseCase executed")
        
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
