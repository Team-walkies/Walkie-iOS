//
//  SceneDelegate.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 11/14/25.
//

import UIKit
import BackgroundTasks

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let diContainer = DIContainer.shared
    private var updateStepBackgroundUseCase: UpdateStepBackgroundUseCase
    private var checkHatchConditionUseCase: CheckHatchConditionUseCase
    private var getTodayStepUseCase: GetTodayStepUseCase
    private var stepStatusStore: StepStatusStore
    
    override init() {
        self.updateStepBackgroundUseCase = diContainer.resolveUpdateStepBackgroundUseCase()
        self.checkHatchConditionUseCase = diContainer.resolveCheckHatchConditionUseCase()
        self.getTodayStepUseCase = diContainer.resolveGetTodayStepUseCase()
        self.stepStatusStore = diContainer.stepStatusStore
        super.init()
        
        BGTaskManager.shared.setStepRefreshHandler { [weak self] task in
            self?.handleStepRefresh(task: task)
        }
        BGTaskManager.shared.setStepGoalHandler { [weak self] task in
            self?.handleCheckStepGoalOnToday(task: task)
        }
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard (scene as? UIWindowScene) != nil else { return }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        if UserManager.shared.hasUserToken {
            NotificationCenter.default.post(name: .appDidEnterBackground, object: nil)
            BGTaskManager.shared.scheduleAppRefresh(.step)
            BGTaskManager.shared.scheduleAppRefresh(.stepGoal)
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if UserManager.shared.hasUserToken {
            NotificationCenter.default.post(name: .appWillEnterForeground, object: nil)
            BGTaskManager.shared.cancelAll()
        }
    }
    
    func handleStepRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        if stepStatusStore.getNeedStep() > 10000 {
            task.setTaskCompleted(success: true)
            return
        }
        
        updateStepBackgroundUseCase.execute { [weak self] in
            guard let self = self else {
                task.setTaskCompleted(success: false)
                return
            }
            
            if self.checkHatchConditionUseCase.execute() {
                NotificationManager.shared.scheduleNotification(
                    title: NotificationType.eggHatch.title,
                    body: NotificationType.eggHatch.body,
                    type: .eggHatch
                )
            } else {
                BGTaskManager.shared.scheduleAppRefresh(.step)
            }
            
            task.setTaskCompleted(success: true)
        }
    }
    
    func handleCheckStepGoalOnToday(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        getTodayStepUseCase.execute { [weak self] result in
            BGTaskManager.shared.scheduleAppRefresh(.stepGoal)
            
            switch result {
            case .success(let todayStep):
                self?.handleStepGoalSuccess(todayStep: todayStep, task: task)
            case .failure(let error):
                task.setTaskCompleted(success: true)
            }
        }
    }
    
    private func handleStepGoalSuccess(todayStep: Int, task: BGAppRefreshTask) {
        let target = UserManager.shared.getTargetStep
        
        guard target > 0, todayStep >= target else {
            task.setTaskCompleted(success: true)
            return
        }
        
        NotificationManager.shared.scheduleNotification(
            title: NotificationType.stepGoal.title,
            body: NotificationType.stepGoal.body,
            type: .stepGoal
        )
        
        task.setTaskCompleted(success: true)
    }
}
