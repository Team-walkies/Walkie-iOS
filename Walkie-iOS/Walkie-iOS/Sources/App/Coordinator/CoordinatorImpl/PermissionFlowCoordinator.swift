//
//  PermissionFlowCoordinator.swift
//  Walkie-iOS
//
//  Created by 고아라 on 7/18/25.
//

import Foundation
import Combine

enum PermissionStep: CaseIterable {
    case locationMotion
    case notification
    
    func alertTitle(
        loc: Bool,
        mot: Bool
    ) -> String {
        switch (loc, mot) {
        case (false, false):
            return "접근권한 허용"
        case (false, true):
            return "위치 권한 허용"
        case (true, false):
            return "동작 및 피트니스 권한 허용"
        case (true, true):
            return ""
        }
    }
    
    func alertContent(
        loc: Bool,
        mot: Bool
    ) -> String {
        switch (loc, mot) {
        case (false, false):
            return "원활한 서비스 이용을 위해 ‘위치’,\n‘동작 및 피트니스’ 권한을 모두 허용해 주세요"
        case (false, true):
            return "스팟을 탐색하기 위해 백그라운드 동작 시의\n위치 정보 접근을 허가해 주세요.\n\n1. 위치를 선택\n2. 위치 접근 허용을 ‘항상'으로 설정"
        case (true, false):
            return "걸음수 측정을 위해 권한이 필요해요"
        default:
            return ""
        }
    }
}

final class PermissionFlowCoordinator {
    
    private let locationUC: LocationPermissionUseCase
    private let motionUC: MotionPermissionUseCase
    private let notifyUC: NotificationPermissionUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private let steps = PermissionStep.allCases
    private var currentIndex: Int = 0
    
    var onDenied: (
        _ step: PermissionStep,
        _ locAllowed: Bool,
        _ motAllowed: Bool,
        _ showBottomSheet: (_ title: String, _ message: String, _ onOK: @escaping () -> Void) -> Void,
        _ showAlert: (_ title: String, _ message: String, _ onOK: @escaping () -> Void) -> Void
    ) -> Void = { _, _, _, _, _ in }
    var onAllAuthorized: () -> Void = {}
    
    init(
        locationUC: LocationPermissionUseCase,
        motionUC: MotionPermissionUseCase,
        notifyUC: NotificationPermissionUseCase
    ) {
        self.locationUC = locationUC
        self.motionUC   = motionUC
        self.notifyUC   = notifyUC
    }
    
    func start() {
        currentIndex = 0
        runCurrentStep()
    }
    
    func nextStep() {
        currentIndex += 1
        runCurrentStep()
    }
    
    private func runCurrentStep() {
        guard currentIndex < steps.count else {
            onAllAuthorized()
            return
        }
        let step = steps[currentIndex]
        switch step {
        case .locationMotion:
            Publishers.CombineLatest(
                locationUC.check(),
                motionUC.check()
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loc, mot in
                self?.handleLocMot(
                    loc: loc,
                    mot: mot,
                    step: .locationMotion
                )
            }
            .store(in: &cancellables)
            
        case .notification:
            notifyUC.check()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] status in
                    self?.handleNotify(status: status, step: .notification)
                }
                .store(in: &cancellables)
        }
    }
    
    private func handleLocMot(
        loc: PermissionState,
        mot: PermissionState,
        step: PermissionStep
    ) {
        let bothAuth = loc == .authorized && mot == .authorized
        let anyNotDetermined = loc == .notDetermined || mot == .notDetermined
        let anyDenied = loc == .denied || mot == .denied
        
        switch () {
        case _ where bothAuth:
            nextStep()
        case _ where anyNotDetermined:
            locationUC.requestIfNeeded()
                .flatMap { _ in self.motionUC.requestIfNeeded() }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.nextStep()
                }
                .store(in: &cancellables)
        case _ where anyDenied:
            onDenied(
                step,
                loc == .authorized,
                mot == .authorized,
                { _, _, _ in },
                { _, _, _ in }
            )
        default:
            break
        }
    }
    
    private func handleNotify(
        status: PermissionState,
        step: PermissionStep
    ) {
        switch status {
        case .authorized:
            nextStep()
        case .notDetermined:
            notifyUC.requestIfNeeded()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.nextStep()
                }
                .store(in: &cancellables)
        case .denied:
            onDenied(
                step,
                true,
                true,
                { _, _, _ in },
                { _, _, _ in }
            )
        }
    }
}
