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
    func requestHealthKitAuthorization(completion: @escaping (Bool) -> Void) {
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
                completion(false)
                return
            }
            
            if success {
                print("권한 요청 성공")
                completion(true)
            } else {
                print("권한이 거부되었습니다.")
                completion(false)
            }
        }
    }
    
    // 걸음 수 읽기 권한 상태 확인
    func checkReadAuthorizationStatus(completion: @escaping (PermissionState) -> Void) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(.denied)
            return
        }
        
        let status = healthStore.authorizationStatus(for: stepCountType)
        if status == .notDetermined {
            completion(.notDetermined)
            return
        }
        
        // 읽기 권한 확인을 위해 간단한 쿼리 실행
        let predicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-86400), end: Date())
        let query = HKSampleQuery(sampleType: stepCountType, predicate: predicate, limit: 1, sortDescriptors: nil) { _, samples, error in
            if let hkError = error as? HKError, hkError.code == .errorAuthorizationDenied {
                completion(.denied)
            } else if samples != nil {
                completion(.authorized)
            } else {
                completion(.denied)
            }
        }
        healthStore.execute(query)
    }
}
