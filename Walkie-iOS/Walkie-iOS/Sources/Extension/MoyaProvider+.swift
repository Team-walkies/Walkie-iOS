//
//  MoyaProvider+.swift
//  Walkie-iOS
//
//  Created by 고아라 on 4/28/25.
//

import Combine
import Moya
import Foundation

extension MoyaProvider {
    
    func requestPublisher(
        _ target: Target,
        reissueService: ReissueService
    ) -> AnyPublisher<Response, MoyaError> {
        self.requestPublisher(target)
            .flatMap { response -> AnyPublisher<Response, MoyaError> in
                switch response.statusCode {
                case 200..<300:
                    return Just(response)
                        .setFailureType(to: MoyaError.self)
                        .eraseToAnyPublisher()
                case 401:
                    return RefreshTokenManager.shared
                        .refresh()
                        .flatMap { _ in self.requestPublisher(target) }
                        .eraseToAnyPublisher()
                default:
                    let error = MoyaError.statusCode(response)
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
