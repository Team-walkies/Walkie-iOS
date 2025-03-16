//
//  HomeService.swift
//  Walkie-iOS
//
//  Created by ahra on 3/12/25.
//

import Moya

import Combine
import CombineMoya

protocol HomeService {
    
    func getEggCount() -> AnyPublisher<EggCountDto, Error>
}

final class DefaultHomeService: HomeService {
    
    private let homeProvider: MoyaProvider<HomeTarget>
    
    init(homeProvider: MoyaProvider<HomeTarget> = MoyaProvider<HomeTarget>(plugins: [NetworkLoggerPlugin()])) {
        self.homeProvider = homeProvider
    }
    
    func getEggCount() -> AnyPublisher<EggCountDto, Error> {
        homeProvider.requestPublisher(.getEggCount)
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(EggCountDto.self)
    }
}
