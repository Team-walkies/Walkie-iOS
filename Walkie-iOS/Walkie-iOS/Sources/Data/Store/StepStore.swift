//
//  StepStore.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 5/3/25.
//

import Foundation

protocol StepStore {
    // 걸음 수 초기화
    func resetStepCountCache()
    // 걸음 수 반환 및 저장
    func getStepCountCache() -> Int
    func setStepCountCache(_ count: Int)
}
