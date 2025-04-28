//
//  DefaultReissueService.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//

import Moya

import Combine
import CombineMoya

final class DefaultReissueService {
    
    private let reissueProvider: MoyaProvider<ReissueTarget>
    
    init(reissueProvider: MoyaProvider<ReissueTarget> = MoyaProvider<ReissueTarget>(plugins: [NetworkLoggerPlugin()])) {
        self.reissueProvider = reissueProvider
    }
}

extension DefaultReissueService: ReissueService {
    
    func reissue(refreshToken: String) -> AnyPublisher<ReissueDto, Error> {
        reissueProvider.requestPublisher(.reissue(refreshToken: refreshToken))
            .filterSuccessfulStatusCodes()
            .mapWalkieResponse(ReissueDto.self)
    }
}
