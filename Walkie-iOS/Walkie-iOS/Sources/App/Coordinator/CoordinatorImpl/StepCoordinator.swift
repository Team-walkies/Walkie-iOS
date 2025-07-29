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
        hatchSubject.share().eraseToAnyPublisher()
    }
    
    // MARK: - UseCases
    private let getEggPlayUseCase: GetEggPlayUseCase
    private let updateStepForegroundUseCase: UpdateStepForegroundUseCase
    private let checkHatchConditionUseCase: CheckHatchConditionUseCase
    private let updateEggStepUseCase: UpdateEggStepUseCase
    private let updateStepBackgroundUseCase: UpdateStepBackgroundUseCase
    private let stepStatusStore: StepStatusStore
    
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
}
