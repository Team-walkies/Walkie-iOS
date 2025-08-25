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
                    completion(.notDetermined)
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
    
    /// 일별 누적
    func getDailySteps(
        from startInclusive: Date
    ) async throws -> [DailySteps] {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthkitError.healthDataUnavailable
        }
        guard
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
            let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { throw HealthkitError.typeUnavailable }
        
        let start = startInclusive.kstStartOfDay
        let end = Date().kstStartOfDay
        
        guard start < end else { return [] }
        
        async let stepsCol = statsCollection(
            quantityType: stepType,
            start: start,
            end: end
        )
        async let distCol = statsCollection(
            quantityType: distanceType,
            start: start,
            end: end
        )
        
        let (steps, distances) = try await (stepsCol, distCol)
        
        var stepsMap: [Date: Int] = [:]
        var distMap: [Date: Double] = [:]
        
        steps.enumerateStatistics(from: start, to: end) { stats, _ in
            guard stats.startDate < end else { return }
            let v = stats.sumQuantity()?.doubleValue(for: .count()) ?? 0
            stepsMap[stats.startDate] = Int(v.rounded())
        }
        distances.enumerateStatistics(from: start, to: end) { stats, _ in
            guard stats.startDate < end else { return }
            let meters = stats.sumQuantity()?.doubleValue(for: .meter()) ?? 0
            distMap[stats.startDate] = meters
        }
        
        var result: [DailySteps] = []
        var current = start
        while current < end {
            let stepDay = stepsMap[current] ?? 0
            let distanceDay = distMap[current] ?? 0
            result.append(DailySteps(
                date: current.ymdKST,
                steps: stepDay,
                distance: ((distanceDay / 1000.0) * 10).rounded() / 10.0
            ))
            let next = current.addingKST(days: 1)
            guard !Date.kstCalendar.isDate(next, inSameDayAs: current) else { break }
            current = next
        }
        
        return result.sorted { $0.date < $1.date }
    }
    
    /// 오늘 누적
    func getTodaySteps() async throws -> DailySteps {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthkitError.healthDataUnavailable
        }
        guard
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
            let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        else { throw HealthkitError.typeUnavailable }
        
        let start = Date().kstStartOfDay
        let end = Date()
        
        async let steps = cumulativeSum(for: stepType, unit: .count(), start: start, end: end)
        async let meters = cumulativeSum(for: distanceType, unit: .meter(), start: start, end: end)
        let (step, meter) = try await (steps, meters)
        
        return DailySteps(
            date: Date.kstYMDFormatter().string(from: start),
            steps: Int(step.rounded()),
            distance: ((meter / 1000.0) * 10).rounded() / 10.0
        )
    }
    
    func getDailySteps(
        from startInclusive: Date,
        completion: @escaping (Result<[DailySteps], Error>) -> Void
    ) {
        Task {
            do {
                let dailySteps = try await getDailySteps(from: startInclusive)
                completion(.success(dailySteps))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTodaySteps(
        completion: @escaping (Result<DailySteps, Error>) -> Void
    ) {
        Task {
            do {
                let todayStep = try await getTodaySteps()
                completion(.success(todayStep))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

private extension HealthKitManager {
    
    func statsCollection(
        quantityType: HKQuantityType,
        start: Date,
        end: Date
    ) async throws -> HKStatisticsCollection {
        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: [.strictStartDate]
        )
        
        return try await withCheckedThrowingContinuation { cont in
            let query = HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: start,
                intervalComponents: DateComponents(day: 1)
            )
            query.initialResultsHandler = { _, collection, error in
                if let error {
                    cont.resume(throwing: error)
                    return
                }
                guard let collection else {
                    cont.resume(throwing: HealthkitError.dateCalculationFailed)
                    return
                }
                cont.resume(returning: collection)
            }
            self.healthStore.execute(query)
        }
    }
    
    /// 구간 합계
    func cumulativeSum(
        for type: HKQuantityType,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> Double {
        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: [.strictStartDate]
        )
        
        return try await withCheckedThrowingContinuation { cont in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, error in
                if let error {
                    cont.resume(throwing: error)
                    return
                }
                let value = stats?.sumQuantity()?.doubleValue(for: unit) ?? 0
                cont.resume(returning: value)
            }
            self.healthStore.execute(query)
        }
    }
}
