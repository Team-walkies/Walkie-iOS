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
                    let token = (try? TokenKeychainManager.shared.getRefreshToken()) ?? ""
                    print("refresh token: 👌👌\(token)👌👌")
                    return reissueService
                        .reissue(refreshToken: token)
                        .mapError { moyaError in
                            moyaError as? MoyaError ?? MoyaError.underlying(moyaError, nil)
                        }
                        .handleEvents(receiveCompletion: { completion in
                            if case .failure = completion {
                                NotificationCenter.default.post(
                                    name: .reissueFailed,
                                    object: nil
                                )
                            }
                        })
                        .flatMap { response -> AnyPublisher<Response, MoyaError> in
                            print("재발급된 토큰들일것임:::: 👌👌\(response)👌👌")
                            do {
                                try TokenKeychainManager.shared.removeTokens()
                                try TokenKeychainManager.shared.saveAccessToken(response.accessToken)
                                try TokenKeychainManager.shared.saveRefreshToken(response.refreshToken)
                                print("👌👌재발급 완료, 원본 파이프라인으로 재요청👌👌")
                            } catch {
                                print("👌👌재발급 실패했으세요")
                            }
                            return self.requestPublisher(target)
                        }
                        .eraseToAnyPublisher()
                default:
                    let error = MoyaError.statusCode(response)
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
