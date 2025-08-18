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
    
    enum HealthkitError: Error {
        case typeUnavailable
        case dateCalculationFailed
        case healthDataUnavailable
    }
    
    struct DailySteps {
        let date: String
        let steps: Int
        let distance: Double
    }
    
    // 걸음 수 읽기 권한 요청
    func requestHealthKitAuthorization(completion: @escaping (PermissionState) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        guard
            let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount),
            let distanceType  = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { return }
        
        let typesToRead: Set<HKObjectType> = [stepCountType, distanceType]
        
        // 권한 요청
        healthStore.requestAuthorization(
            toShare: [],
            read: typesToRead
        ) { (_, error) in
            if let error = error {
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
            completion(.denied)
            return
        }
        
        let status = healthStore.authorizationStatus(for: stepCountType)
        if status == .notDetermined {
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
            limit: 1,
            sortDescriptors: nil
        ) { _, samples, error in
            if
                let hkError = error as? HKError,
                hkError.code == .errorAuthorizationDenied {
                completion(.denied)
            } else if samples?.count ?? 0 > 0 {
                completion(.authorized)
            } else {
                completion(.denied)
            }
        }
        healthStore.execute(query)
    }
    
    func getDailySteps(
        from startInclusive: Date,
        completion: @escaping (Result<[DailySteps], Error>) -> Void
    ) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(HealthkitError.healthDataUnavailable)); return
        }
        guard
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
            let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        else {
            completion(.failure(HealthkitError.typeUnavailable)); return
        }
        
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        let start = cal.startOfDay(for: startInclusive)
        let end = cal.startOfDay(for: Date())
        
        guard start < end else {
            completion(.success([]))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: [.strictStartDate]
        )
        let interval = DateComponents(day: 1)
        let anchor = start
        
        let dayFormatter: DateFormatter = {
            let f = DateFormatter()
            f.calendar = cal
            f.timeZone = cal.timeZone
            f.dateFormat = "yyyy-MM-dd"
            return f
        }()
        
        var stepsMap: [Date: Int] = [:]
        var distanceMap: [Date: Double] = [:]
        
        let group = DispatchGroup()
        var firstError: Error?
        
        let stepQuery = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchor,
            intervalComponents: interval
        )
        group.enter()
        stepQuery.initialResultsHandler = { _, collection, error in
            defer { group.leave() }
            if let error = error { firstError = error; return }
            guard let collection = collection else { return }
            
            collection.enumerateStatistics(from: start, to: end) { stats, _ in
                guard stats.startDate < end else { return } // 오늘 버킷 제외
                let v = stats.sumQuantity()?.doubleValue(for: .count()) ?? 0
                stepsMap[stats.startDate] = Int(v.rounded())
            }
        }
        healthStore.execute(stepQuery)
        
        let distanceQuery = HKStatisticsCollectionQuery(
            quantityType: distanceType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchor,
            intervalComponents: interval
        )
        group.enter()
        distanceQuery.initialResultsHandler = { _, collection, error in
            defer { group.leave() }
            guard error == nil, let collection = collection else { return }
            
            collection.enumerateStatistics(from: start, to: end) { stats, _ in
                guard stats.startDate < end else { return }
                let meters = stats.sumQuantity()?.doubleValue(for: .meter()) ?? 0
                distanceMap[stats.startDate] = meters
            }
        }
        healthStore.execute(distanceQuery)
        
        group.notify(queue: .main) {
            if let e = firstError {
                completion(.failure(e)); return
            }
            
            var result: [DailySteps] = []
            var d = start
            while d < end {
                let s = stepsMap[d] ?? 0
                let dist = distanceMap[d] ?? 0
                let dayString = dayFormatter.string(from: d)
                result.append(DailySteps(
                    date: dayString,
                    steps: s,
                    distance: ((dist / 1000.0) * 10).rounded() / 10.0)
                )
                
                guard let next = cal.date(byAdding: .day, value: 1, to: d) else { break }
                d = next
            }
            
            result.sort { $0.date < $1.date }
            completion(.success(result))
        }
    }
}
