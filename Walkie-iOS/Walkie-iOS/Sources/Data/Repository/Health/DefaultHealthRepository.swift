//
//  DefaultHealthRepository.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Combine

final class DefaultHealthRepository {
    
    // MARK: - Dependency
    
    private let healthService: HealthService
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(healthService: HealthService) {
        self.healthService = healthService
    }
}

extension DefaultHealthRepository: HealthRepository {
    
    func getHealth(param: HealthDateDto) -> AnyPublisher<[String: HealthWeekEntity], any Error> {
        healthService
            .getHealth(param: param)
            .map { dtos in
                let dict = dtos.reduce(into: [String: HealthWeekEntity]()) { dic, dto in
                    dic[dto.responseDate] = HealthWeekEntity(
                        nowStep: dto.nowSteps,
                        targetStep: dto.targetSteps
                    )
                }
                return dict
            }
            .eraseToAnyPublisher()
    }
    
    func getHealthDetail(searchDate: String) -> AnyPublisher<HealthDetailDto, any Error> {
        healthService
            .getHealthDetail(searchDate: searchDate)
            .eraseToAnyPublisher()
    }
    
    func getHealthContinueDay() -> AnyPublisher<Int, any Error> {
        healthService
            .getHealthContinueDay()
            .map { dto in
                dto.continuousDays
            }
            .eraseToAnyPublisher()
    }
    
    func putHealth(request: HealthRequestDto) -> AnyPublisher<Void, any Error> {
        healthService
            .putHealth(request: request)
            .eraseToAnyPublisher()
    }
}
