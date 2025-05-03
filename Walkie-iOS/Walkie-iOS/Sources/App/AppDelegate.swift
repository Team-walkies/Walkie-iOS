//
//  AppDelegate.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import UIKit
import BackgroundTasks

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let checkStepUseCase = DIContainer.shared.resolveCheckStepUseCase()
    private let updateStepUseCase = DIContainer.shared.resolveUpdateStepUseCase()
    
    /// 앱 실행시 호출
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        print("[DEBUG][AppDelegate][didFinishLaunching] App launched with options: \(launchOptions?.description ?? "none")")
        
        // 백그라운드 작업 등록
        registerBackgroundTasks()
        
        print("[DEBUG][AppDelegate][didFinishLaunching] Executing UpdateStepUseCase...")
        updateStepUseCase.execute()
        print("[DEBUG][AppDelegate][didFinishLaunching] UpdateStepUseCase completed")
        
        print("[DEBUG][AppDelegate][didFinishLaunching] Executing CheckStepUseCase...")
        checkStepUseCase.execute()
        print("[DEBUG][AppDelegate][didFinishLaunching] CheckStepUseCase completed")
        
        // 백그라운드 작업 스케줄링
        scheduleBackgroundTasks()
        
        print("[DEBUG][AppDelegate][didFinishLaunching] App initialization completed")
        return true
    }
    
    /// 앱 Foreground로 전환 시 호출
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("[DEBUG][AppDelegate][didBecomeActive] App became active")
        
        print("[DEBUG][AppDelegate][didBecomeActive] Executing UpdateStepUseCase...")
        updateStepUseCase.execute()
        print("[DEBUG][AppDelegate][didBecomeActive] UpdateStepUseCase completed")
        
        print("[DEBUG][AppDelegate][didBecomeActive] Executing CheckStepUseCase...")
        checkStepUseCase.execute()
        print("[DEBUG][AppDelegate][didBecomeActive] CheckStepUseCase completed")
    }
    
    /// 앱 비활성 상태(앱 전환, 전화 수신) 전환 시 호출
    func applicationWillResignActive(_ application: UIApplication) {
        print("[DEBUG][AppDelegate][willResignActive] App will resign active")
        // 데이터는 이미 UserDefaults에 저장됨
    }
    
    /// 앱 Background로 전환 시 호출
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("[DEBUG][AppDelegate][didEnterBackground] App entered background")
        
        print("[DEBUG][AppDelegate][didEnterBackground] Executing UpdateStepUseCase...")
        updateStepUseCase.execute()
        print("[DEBUG][AppDelegate][didEnterBackground] UpdateStepUseCase completed")
        
        // 백그라운드 작업 스케줄링
        scheduleBackgroundTasks()
    }
    
    /// 앱 Background -> Foreground로 돌아올 시 호출
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("[DEBUG][AppDelegate][willEnterForeground] App will enter foreground")
        
        print("[DEBUG][AppDelegate][willEnterForeground] Executing UpdateStepUseCase...")
        updateStepUseCase.execute()
        print("[DEBUG][AppDelegate][willEnterForeground] UpdateStepUseCase completed")
        
        print("[DEBUG][AppDelegate][willEnterForeground] Executing CheckStepUseCase...")
        checkStepUseCase.execute()
        print("[DEBUG][AppDelegate][willEnterForeground] CheckStepUseCase completed")
    }
    
    /// 앱 종료시 호출
    func applicationWillTerminate(_ application: UIApplication) {
        print("[DEBUG][AppDelegate][willTerminate] App will terminate")
        // 데이터는 이미 UserDefaults에 저장됨
    }
    
    private enum BackgroundTaskIdentifier: String, CaseIterable {
        case checkStep = "com.walkie.ios.check.step"
        case updateStep = "com.walkie.ios.update.step"
    }
    
    // MARK: - Background Task Registration
    private func registerBackgroundTasks() {
        // checkStep 작업 등록
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.checkStep.rawValue,
            using: nil
        ) { task in
            self.handleCheckStepTask(task: task)
        }
        
        // updateStep 작업 등록
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.updateStep.rawValue,
            using: nil
        ) { task in
            self.handleUpdateStepTask(task: task)
        }
        
        print("[DEBUG][AppDelegate][registerBackgroundTasks] Background tasks registered")
    }
    
    // MARK: - Background Task Handlers
    private func handleCheckStepTask(task: BGTask) {
        print("[DEBUG][AppDelegate][handleCheckStepTask] Starting checkStep background task")
        
        // 작업 만료 처리
        task.expirationHandler = {
            print("[DEBUG][AppDelegate][handleCheckStepTask] CheckStep task expired")
            task.setTaskCompleted(success: false)
        }
        
        // checkStepUseCase 실행
        checkStepUseCase.execute()
        print("[DEBUG][AppDelegate][handleCheckStepTask] CheckStepUseCase executed")
        
        // 작업 완료
        task.setTaskCompleted(success: true)
        
        // 작업 재스케줄링
        scheduleBackgroundTasks()
    }
    
    private func handleUpdateStepTask(task: BGTask) {
        print("[DEBUG][AppDelegate][handleUpdateStepTask] Starting updateStep background task")
        
        // 작업 만료 처리
        task.expirationHandler = {
            print("[DEBUG][AppDelegate][handleUpdateStepTask] UpdateStep task expired")
            task.setTaskCompleted(success: false)
        }
        
        // updateStepUseCase 실행
        updateStepUseCase.execute()
        print("[DEBUG][AppDelegate][handleUpdateStepTask] UpdateStepUseCase executed")
        
        // 작업 완료
        task.setTaskCompleted(success: true)
        
        // 작업 재스케줄링
        scheduleBackgroundTasks()
    }
    
    // MARK: - Background Task Scheduling
    private func scheduleBackgroundTasks() {
        // checkStep 작업 스케줄링
        let checkStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.checkStep.rawValue)
        checkStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 10) // 10초 후
        
        do {
            try BGTaskScheduler.shared.submit(checkStepRequest)
            print("[DEBUG][AppDelegate][scheduleBackgroundTasks] CheckStep task scheduled")
        } catch {
            print("[DEBUG][AppDelegate][scheduleBackgroundTasks] Failed to schedule CheckStep task: \(error)")
        }
        
        // updateStep 작업 스케줄링
        let updateStepRequest = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.updateStep.rawValue)
        updateStepRequest.earliestBeginDate = Date(timeIntervalSinceNow: 10) // 10초 후
        
        do {
            try BGTaskScheduler.shared.submit(updateStepRequest)
            print("[DEBUG][AppDelegate][scheduleBackgroundTasks] UpdateStep task scheduled")
        } catch {
            print("[DEBUG][AppDelegate][scheduleBackgroundTasks] Failed to schedule UpdateStep task: \(error)")
        }
    }
}
