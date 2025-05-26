//
//  StepManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/6/25.
//

import Combine
import BackgroundTasks

final class StepManager {
    
    // 부화 이벤트 Publisher
    let hatchEventSubject = PassthroughSubject<Void, Never>()
    // 걸음 수 캐시 업데이트 Publisher
    let updateCacheEventSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private let getEggPlayUseCase: GetEggPlayUseCase
    private let updateEggStepUseCase: UpdateEggStepUseCase
    private let checkStepUseCase: CheckStepUseCase
    private let updateStepCacheUseCase: UpdateStepCacheUseCase
    private var eggEntity: EggEntity?
    
    private enum BackgroundTaskIdentifier: String, CaseIterable {
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
        getEggPlayingAndThenUpdateStep()
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
                        self.eggEntity = nil
                    }
                },
                receiveValue: { [weak self] eggEntityValue in
                    self?.eggEntity = eggEntityValue
                    UserManager.shared.setStepCount(eggEntityValue.nowStep)
                    UserManager.shared.setStepCountGoal(eggEntityValue.needStep)
                    self?.updateForeground()
                }
            )
            .store(in: &cancellables)
    }
    
    func updateStepCache() {
        updateStepCacheUseCase.execute {
            self.updateCacheEventSubject.send(())
        }
    }
    
    // 서버에 걸음 수 업데이트
    func updateForeground() {
        if let egg = self.eggEntity {
            self.updateEggStepUseCase.execute(
                egg: egg,
                step: UserManager.shared.getStepCount,
                willHatch: false) {
                    
                }
        }
    }
    
    // 걷고있는 알 변경
    func changeEggPlaying(egg: EggEntity) {
        self.eggEntity = egg
    }
    
    // MARK: 포그라운드 테스크
    ///
    func executeForegroundTasks() {
        updateStepCacheUseCase.execute { [weak self] in
            self?.handleHatchingCondition(shouldUpdateForeground: true)
        }
    }
    
    func executeBackgroundTasks() {
        updateStepCacheUseCase.execute { [weak self] in
            self?.handleHatchingCondition(shouldUpdateForeground: false)
        }
    }
    
    // MARK: - Background Task Scheduling
    
    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.updateStep.rawValue,
            using: nil
        ) { [weak self] task in
            self?.handleUpdateStepTask(task: task)
        }
    }
    
    private func handleUpdateStepTask(task: BGTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        updateStepCacheUseCase.execute() {
            self.handleHatchingCondition(shouldUpdateForeground: false)
        }
        task.setTaskCompleted(success: true)
    }
    
    // MARK: - Helper Methods
    
    // 부화 조건 확인
    /// 포그라운드인 경우 서버에 업데이트
    /// 백그라운드인 경우 부화 알림 전송 + 백그라운드 테스크 스케줄링 중단
    private func handleHatchingCondition(shouldUpdateForeground: Bool) {
        if checkStepUseCase.execute() { // 부화 조건 확인
            // 부화 조건인 경우
            if shouldUpdateForeground {
                hatchEventSubject.send(()) // 부화 UI 및 서버 처리
                // 부화 조건에 도달한 경우 더이상 스케줄링 하지 않음
            }
        } else {
            // 부화 조건이 아닌 경우
            if shouldUpdateForeground {
                updateForeground() // 서버 업데이트 처리
            } else {
                scheduleBackgroundTasks() // 백그라운드 업데이트 지속
            }
        }
    }
    
    // 백그라운드 태스크 스케줄링
    private func scheduleTask(identifier: String, earliestBeginDate: Date) {
        let taskRequest = BGAppRefreshTaskRequest(identifier: identifier)
        taskRequest.earliestBeginDate = earliestBeginDate
        
        do {
            try BGTaskScheduler.shared.submit(taskRequest)
            print("[DEBUG][StepManager][scheduleTask] \(identifier) task scheduled")
        } catch {
            print("[DEBUG][StepManager][scheduleTask] Failed to schedule \(identifier) task: \(error)")
        }
    }
    
    // 백그라운드 태스크 스케줄링 관리
    private func scheduleBackgroundTasks() {
        let earliestDate = Date(timeIntervalSinceNow: 60)
        scheduleTask(identifier: BackgroundTaskIdentifier.updateStep.rawValue, earliestBeginDate: earliestDate)
    }
}
