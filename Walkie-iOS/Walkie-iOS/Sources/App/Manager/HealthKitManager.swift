//
//  HealthKitManager.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 8/5/25.
//

import HealthKit

final class HealthKitManager {
    
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    // 걸음 수 읽기 권한 요청
    func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        let typesToRead: Set<HKObjectType> = [stepCountType]
        let typesToShare: Set<HKSampleType> = []
        
        // 권한 요청
        healthStore.requestAuthorization(
            toShare: typesToShare,
            read: typesToRead
        ) { (success, error) in
            if let error = error {
                print("권한 요청 실패: \(error.localizedDescription)")
                return
            }
            
            if success {
                print("권한 요청 성공")
            } else {
                print("권한이 거부되었습니다.")
            }
        }
    }
    
    // 걸음 수 읽기 권한 확인
    func checkAuthorizationStatus() -> PermissionState {
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let status = healthStore.authorizationStatus(for: stepCountType)
        
        switch status {
        case .notDetermined:
            return .notDetermined
        case .sharingDenied:
            return .denied
        case .sharingAuthorized:
            return .authorized
        @unknown default:
            return .denied
        }
    }
}
