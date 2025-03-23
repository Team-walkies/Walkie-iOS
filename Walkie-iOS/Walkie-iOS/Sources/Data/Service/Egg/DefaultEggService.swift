//
//  DefaultEggService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Moya
import Combine

final class DefaultEggService {
    
    private let eggProvider: MoyaProvider<EggTarget>
    
    init(eggProvider: MoyaProvider<EggTarget> = MoyaProvider<EggTarget>(plugins: [NetworkLoggerPlugin()])) {
        self.eggProvider = eggProvider
    }
}

extension DefaultEggService: EggService {
    
    func getEggsList() -> AnyPublisher<GetEggListDto, Error> {
        eggProvider.requestPublisher(.getEggsList)
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetEggListDto.self)
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<GetEggDetailDto, Error> {
        eggProvider.requestPublisher(.getEggDetail(eggId: eggId))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetEggDetailDto.self)
    }
    
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Int?, Error> {
        eggProvider.requestPublisher(.patchEggStep(requestBody: requestBody))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(Int?.self)
    }
    
    func getEggsCount() -> AnyPublisher<EggCountDto, Error> {
        eggProvider.requestPublisher(.getEggsCount)
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(EggCountDto.self)
    }
}
