//
//  StepStore.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import Foundation

protocol StepStore {
    // 걸음 수 초기화
    func resetStepCount()
    // 걸음 수 반환 및 저장
    func getStepCount() -> Result<Int, StepStoreError>
    func saveStepCount(_ count: Int)
    // 목표치 반환
    func getStepCountGoal() -> Result<Int, StepStoreError>
}

enum StepStoreError: Error {
    case noDataFound
}
