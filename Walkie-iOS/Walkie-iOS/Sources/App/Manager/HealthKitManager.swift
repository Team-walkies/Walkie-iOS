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
    func requestHealthKitAuthorization(completion: @escaping (PermissionState) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            /// HealthKit이 해당 기기에서 사용 불가한 경우
            /// 기업 환경에서 실행되는 기기의 경우 제한이 걸려있을 수 있음
            completion(.denied)
            return
        }
        
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            /// identifier 매핑 오류의 경우입니다
            /// 절대 발생하지 않으나 일단 guard let 바인딩 처리
            return
        }
        
        let typesToRead: Set<HKObjectType> = [stepCountType]
        
        // 권한 요청
        healthStore.requestAuthorization(
            toShare: [],
            read: typesToRead
        ) { (_, error) in
            if let error = error {
                /// 권한 팝업 띄우기 실패한 경우
                /// 다음에 다시 요청 가능한 상태이므로 .notDemtermined를 반환합니다
                print("권한 요청 실패: \(error.localizedDescription)")
                completion(.notDetermined)
                return
            }
            self.checkReadAuthorizationStatus { permissionState in
                completion(permissionState)
            }
        }
    }
    
    // 걸음 수 읽기 권한 상태 확인
    func checkReadAuthorizationStatus(completion: @escaping (PermissionState) -> Void) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(.notDetermined)
            return
        }
        
        // 읽기 권한 확인을 위해 간단한 쿼리 실행
        let predicate = HKQuery.predicateForSamples(
            withStart: Date().addingTimeInterval(-86400*7),
            end: Date()
        )
        let query = HKSampleQuery(
            sampleType: stepCountType,
            predicate: predicate,
            limit: 1, // 시작 시점부터 최대 1개만 쿼리
            sortDescriptors: nil,
        ) { _, samples, _ in
            if samples?.count ?? 0 > 0 { // 1개가 쿼리된 경우
                completion(.authorized)
            } else {
                completion(.denied)
            }
        }
        healthStore.execute(query)
    }
}
