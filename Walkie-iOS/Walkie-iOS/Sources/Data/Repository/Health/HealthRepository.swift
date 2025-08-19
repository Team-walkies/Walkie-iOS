//
//  HealthRepository.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Combine

protocol HealthRepository {
    func getHealth(param: HealthDateDto) -> AnyPublisher<[String: HealthWeekEntity], Error>
    func getHealthDetail(searchDate: String) -> AnyPublisher<HealthDetailDto, Error>
    func getHealthContinueDay() -> AnyPublisher<Int, Error>
    func putHealth(request: HealthRequestDto) -> AnyPublisher<Void, Error>
}
