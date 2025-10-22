//
//  StepCoordinator.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/31/25.
//

import Combine
import BackgroundTasks
import Observation

@Observable
final class StepCoordinator {
    private let diContainer: DIContainer
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Publishers
    private let hatchSubject = PassthroughSubject<Bool, Error>()
    var hatchPublisher: AnyPublisher<Bool, Error> {
        hatchSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UseCases
    private let getEggPlayUseCase: GetEggPlayUseCase
    private let updateStepForegroundUseCase: UpdateStepForegroundUseCase
    private let checkHatchConditionUseCase: CheckHatchConditionUseCase
    private let updateEggStepUseCase: UpdateEggStepUseCase
    private let updateStepBackgroundUseCase: UpdateStepBackgroundUseCase
    private let stepStatusStore: StepStatusStore
    private let getTodayStepUseCase: GetTodayStepUseCase
    
    // MARK: - AppCoordinator
    private weak var appCoordinator: AppCoordinator?
    
    init(diContainer: DIContainer, appCoordinator: AppCoordinator) {
        self.diContainer = diContainer
        self.appCoordinator = appCoordinator
        self.getEggPlayUseCase = diContainer.resolveGetEggPlayUseCase()
        self.updateStepForegroundUseCase = diContainer.resolveUpdateStepForegroundUseCase()
        self.checkHatchConditionUseCase = diContainer.resolveCheckHatchConditionUseCase()
        self.updateEggStepUseCase = diContainer.resolveUpdateEggStepUseCase()
        self.updateStepBackgroundUseCase = diContainer.resolveUpdateStepBackgroundUseCase()
        self.stepStatusStore = diContainer.stepStatusStore
        self.getTodayStepUseCase = diContainer.resolveGetTodayStepUseCase()
    }
    
    // MARK: - Foreground 걸음 수 측정
    func fetchEggPlay(completion: @escaping (Result<EggEntity, Error>) -> Void) {
        getEggPlayUseCase.execute()
            .walkieSink(
                with: self,
                receiveValue: { _, egg in
                    print("🥚 같이 걷는 알 가져오기 성공 🥚")
                    dump(egg)
                    completion(.success(egg))
                },
                receiveFailure: { _, error in
                    print("🥚 같이 걷는 알 가져오기 실패 : \(String(describing: error?.localizedDescription))🥚")
                    completion(.failure(error ?? .emptyDataError))
                }
            )
            .store(in: &cancellables)
    }
    
    func startStepQuery(onUpdate: @escaping () -> Void) {
        updateStepForegroundUseCase.start()
            .map { _ in () }
            .prepend(()) 
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("🏃 포그라운드 걸음 수 쿼리 실패 : \(error.localizedDescription) 🏃")
                    }
                },
                receiveValue: { _ in
                    onUpdate()
                }
            )
            .store(in: &cancellables)
    }
    
    func checkHatchCondition() -> Bool {
        checkHatchConditionUseCase.execute()
    }
    
    func presentHatchEggScreen() {
        hatchSubject.send(true)
        stopStepUpdates()
    }
    
    func startStepUpdates() {
        stopStepUpdates() // 기존 쿼리 정리
        
        fetchEggPlay { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let egg):
                startStepQuery { [weak self] in
                    guard let self else { return }
                    let newStep = stepStatusStore.getNowStep()
                    
                    if checkHatchCondition() {
                        presentHatchEggScreen()
                    } else {
                        updateEggStepUseCase.execute(egg: egg, step: newStep, willHatch: false) {
                            self.hatchSubject.send(false)
                        }
                    }
                }
            case .failure:
                self.hatchSubject.send(false)
                stopStepUpdates()
            }
        }
    }
    
    func stopStepUpdates() {
        updateStepForegroundUseCase.stop()
        cancellables.removeAll()
    }
    
    // MARK: - Background 걸음 수 측정
    func handleStepRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("⏳ 백그라운드 테스크 만료 ⏳")
            task.setTaskCompleted(success: false)
        }
        
        if stepStatusStore.getNeedStep() > 10000 {
            task.setTaskCompleted(success: true)
            print("⏳ 백그라운드 걸음 수 업데이트 및 스케줄링 하지 않음 : 알 없음 ⏳")
            return
        }
        
        updateStepBackgroundUseCase.execute()
        print("⏳ 백그라운드 걸음 수 업데이트 완료 ⏳")
        task.setTaskCompleted(success: true)
        
        if checkHatchCondition() {
            print("⏳ 백그라운드 걸음 수 업데이트 스케줄링 중단 : 부화 조건 달성, 푸시 알림 전송 ⏳")
            NotificationManager.shared.scheduleNotification(
                title: NotificationLiterals.eggHatch.title,
                body: NotificationLiterals.eggHatch.body
            )
        } else {
            print("⏳ 백그라운드 걸음 수 업데이트 스케줄링 ⏳")
            BGTaskManager.shared.scheduleAppRefresh(.step)
        }
    }
    
    // MARK: - Background 오늘 목표 걸음 달성 여부 확인
    func handleCheckStepGoalOnToday(task: BGAppRefreshTask) {
        dump("백그라운드 테스크 시작-오늘 목표 걸음")
        dump("목표 걸음 : \(UserManager.shared.getTargetStep)")
        
        // 만료 핸들러를 비동기 작업 시작 전에 설정
        task.expirationHandler = {
            print("⏳ 백그라운드 테스크 만료 ⏳")
            task.setTaskCompleted(success: false)
        }
        
        getTodayStepUseCase.execute { [weak self] result in
            // 비동기 작업 완료 후 다음 스케줄링
            BGTaskManager.shared.scheduleAppRefresh(.stepGoal)
            
            switch result {
            case .success(let todayStep):
                self?.handleStepGoalSuccess(todayStep: todayStep, task: task)
            case .failure(let error):
                print("⏳ 오늘 걸음 수 조회 실패: \(error.localizedDescription) ⏳")
                task.setTaskCompleted(success: true) // 실패해도 task 완료 처리
            }
        }
    }
    
    private func handleStepGoalSuccess(todayStep: Int, task: BGAppRefreshTask) {
        let target = UserManager.shared.getTargetStep
        
        // 목표 걸음 수가 설정되지 않았거나 달성하지 못한 경우
        guard target > 0, todayStep >= target else {
            dump("목표 미달성 - 목표: \(target), 현재: \(todayStep)")
            task.setTaskCompleted(success: true)
            return
        }
        
        // 오늘 이미 알림을 보낸 경우
        if UserManager.shared.hasNotifiedStepGoalToday() {
            dump("오늘 이미 목표 걸음 달성 알림 전송됨")
            task.setTaskCompleted(success: true)
            return
        }
        
        // 목표 달성 알림 전송
        dump("오늘 걸음 : \(todayStep), 목표 달성!")
        NotificationManager.shared.scheduleStepGoalNotification(
            title: "목표 걸음 수를 채웠어요!",
            body: "지금 바로 알을 얻어보세요"
        )
        
        // 알림 전송 날짜 기록
        UserManager.shared.markStepGoalNotificationSent()
        task.setTaskCompleted(success: true)
    }
}
