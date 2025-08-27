//
//  HealthService.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Combine

protocol HealthService {
    func getHealth(param: HealthDateDto) -> AnyPublisher<[HealthDto], Error>
    func getHealthDetail(searchDate: String) -> AnyPublisher<HealthDetailDto, Error>
    func getHealthContinueDay() -> AnyPublisher<HealthContinueDaysDto, Error>
    func putHealth(request: HealthRequestDto) -> AnyPublisher<Void, Error>
    func getHealthLastDataDays() -> AnyPublisher<HealthLastDateDto, Error>
}
