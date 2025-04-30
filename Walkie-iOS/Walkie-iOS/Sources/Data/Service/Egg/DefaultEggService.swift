//
//  DefaultEggService.swift
//  Walkie-iOS
//
//  Created by 황채웅 on 3/22/25.
//

import Moya
import Combine
import CombineMoya

final class DefaultEggService {
    
    private let eggProvider: MoyaProvider<EggTarget>
    private let reissueService: DefaultReissueService
    
    init(
        eggProvider: MoyaProvider<EggTarget> = MoyaProvider<EggTarget>(plugins: [NetworkLoggerPlugin()]),
        reissueService: DefaultReissueService
    ) {
        self.eggProvider = eggProvider
        self.reissueService = reissueService
    }
}

extension DefaultEggService: EggService {
    
    func getEggsList() -> AnyPublisher<GetEggListDto, Error> {
        eggProvider
            .requestPublisher(
                .getEggsList,
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetEggListDto.self)
    }
    
    func getEggDetail(eggId: Int) -> AnyPublisher<GetEggDetailDto, Error> {
        eggProvider
            .requestPublisher(
                .getEggDetail(eggId: eggId),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(GetEggDetailDto.self)
    }
    
    func patchEggStep(requestBody: PatchEggStepRequestDto) -> AnyPublisher<Void, Error> {
        eggProvider
            .requestPublisher(
                .patchEggStep(requestBody: requestBody),
                reissueService: reissueService
            )
            .filterSuccessfulStatusCodes()
            .mapVoidResponse()
    }
    
    func getEggsCount() -> AnyPublisher<EggCountDto, Error> {
        eggProvider
            .requestPublisher(
                .getEggsCount,
                reissueService: reissueService
            )
            .mapWalkieResponse(EggCountDto.self)
    }
}
