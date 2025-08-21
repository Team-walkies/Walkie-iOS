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
        guard HKHealthStore.isHealthDataAvailable() else {
            /// HealthKit이 해당 기기에서 사용 불가한 경우
            /// 기업 환경에서 실행되는 기기의 경우 제한이 걸려있을 수 있음
            completion(.denied)
            return
        }
        
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
        guard
            let step = HKObjectType.quantityType(forIdentifier: .stepCount),
            let dist = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else {
            completion(.notDetermined)
            return
        }
        
        healthStore.getRequestStatusForAuthorization(
            toShare: [],
            read: [step, dist]
        ) { status, error in
            DispatchQueue.main.async {
                if error != nil { completion(.notDetermined); return }
                
                switch status {
                case .shouldRequest:
                    completion(.notDetermined)   // 아직 권한 안 물어봄
                case .unnecessary:
                    self.probeReadAuthorization { granted in
                        completion(granted ? .authorized : .denied)
                    }
                case .unknown:
                    completion(.notDetermined)
                @unknown default:
                    completion(.notDetermined)
                }
            }
        }
    }
    
    private func probeReadAuthorization(_ done: @escaping (Bool) -> Void) {
        guard let step = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            done(false); return
        }
        let from = Date().addingTimeInterval(-3600)
        let pred = HKQuery.predicateForSamples(withStart: from, end: Date())
        let q = HKStatisticsQuery(
            quantityType: step,
            quantitySamplePredicate: pred,
            options: .cumulativeSum
        ) { _, _, error in
            if let hkErr = error as? HKError, hkErr.code == .errorAuthorizationDenied {
                done(false)
            } else {
                done(true)
            }
        }
        healthStore.execute(q)
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
    
    func getTodaySteps(
        completion: @escaping (Result<DailySteps, Error>) -> Void
    ) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(HealthkitError.healthDataUnavailable)); return
        }
        guard
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
            let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { completion(.failure(HealthkitError.typeUnavailable)); return }
        
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        
        let start = cal.startOfDay(for: Date())
        let end = Date()
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let group = DispatchGroup()
        var steps: Double = 0
        var meters: Double = 0
        var firstError: Error?
        
        func sum(_ qt: HKQuantityType, unit: HKUnit, storeTo: @escaping (Double) -> Void) {
            let q = HKStatisticsQuery(
                quantityType: qt,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, error in
                if let error = error { firstError = error }
                let v = stats?.sumQuantity()?.doubleValue(for: unit) ?? 0
                storeTo(v)
                group.leave()
            }
            group.enter(); healthStore.execute(q)
        }
        
        sum(stepType, unit: .count()) { steps = $0 }
        sum(distanceType, unit: .meter()) { meters = $0 }
        
        let dayFormatter: DateFormatter = {
            let f = DateFormatter()
            f.calendar = cal
            f.timeZone = cal.timeZone
            f.dateFormat = "yyyy-MM-dd"
            return f
        }()
        
        group.notify(queue: .main) {
            if let e = firstError { completion(.failure(e)); return }
            completion(.success(DailySteps(
                date: dayFormatter.string(from: start),
                steps: Int(steps.rounded()),
                distance: ((meters / 1000.0) * 10).rounded() / 10.0
            )))
        }
    }
}
