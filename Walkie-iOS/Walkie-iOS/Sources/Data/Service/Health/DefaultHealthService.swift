//
//  DefaultHealthService.swift
//  Walkie-iOS
//
//  Created by 고아라 on 8/18/25.
//

import Moya
import Combine

final class DefaultHealthService: HealthService {
    
    private let healthProvider: MoyaProvider<HealthTarget>
    private let reissueService: DefaultReissueService
    
    init(
        healthProvider: MoyaProvider<HealthTarget> = MoyaProvider<HealthTarget>(plugins: [NetworkLoggerPlugin()]),
        reissueService: DefaultReissueService
    ) {
        self.healthProvider = healthProvider
        self.reissueService = reissueService
    }
    
    func getHealth(param: HealthDateDto) -> AnyPublisher<[HealthDto], Error> {
        healthProvider
            .requestPublisher(
                .health(param: param),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse([HealthDto].self)
    }
    
    func getHealthDetail(searchDate: String) -> AnyPublisher<HealthDetailDto, Error> {
        healthProvider
            .requestPublisher(
                .healthDetail(searchDate: searchDate),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(HealthDetailDto.self)
    }
    
    func getHealthContinueDay() -> AnyPublisher<HealthContinueDaysDto, Error> {
        healthProvider
            .requestPublisher(
                .healthContinueDays(),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(HealthContinueDaysDto.self)
    }
    
    func putHealth(request: HealthRequestDto) -> AnyPublisher<Void, Error> {
        healthProvider
            .requestPublisher(
                .healthUpdate(request: request),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()
    }
    
    func getHealthLastDataDays() -> AnyPublisher<HealthLastDateDto, Error> {
        healthProvider
            .requestPublisher(
                .healthLastDataDays(),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(HealthLastDateDto.self)
    }
}
